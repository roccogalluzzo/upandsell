class CheckoutsController < ApplicationController

  skip_before_filter :verify_authenticity_token, only: [:ipn]
  skip_after_filter :intercom_rails_auto_include

  def pay_info
    product = Product.find(params[:product_id])
    render json: { price: product.price_cents, currency: product.price_currency.upcase }
  end

  def check_coupon
    coupon = Coupon.find_by_code params[:code]
    if coupon && coupon.active?
      new_price =  coupon.discounted_price
      int, cents = new_price.to_s.split('.')
      return render json: {id: coupon.id, price: new_price.to_s, sym: new_price.symbol, int: int, cents: cents}
    end
    render json: {}, status: :not_found
  end

  def braintree_token
    user = User.find(Product.find(params[:product_id]).user_id)

    Braintree::Configuration.merchant_id = user.credit_card_bt_merchant_id
    Braintree::Configuration.public_key = user.credit_card_public_token
    Braintree::Configuration.private_key = user.credit_card_token
    render json: { token: Braintree::ClientToken.generate }, status: :ok
  end

  def pay
    product = Product.find(params[:product_id])
    unless params[:gateway] == 'paymill' || params[:gateway] == 'stripe' || params[:gateway] == 'braintree'
      render json: {error: order}, status: :unauthorized and return
    end
    new_price = nil
    if params[:coupon_id]
      coupon = Coupon.find params[:coupon_id]
      if coupon && coupon.active? && coupon.product.id = product.id
        new_price =  coupon.discounted_price.cents
        coupon_id = coupon.id
      end
    end
    order = PaymentService.new(params[:gateway])
    .pay(product, {coupon_id: coupon_id || nil, email: params[:email], token: params[:token], new_price: new_price})

    if order && order.status == 'completed'
      if coupon && coupon.active? && coupon.product.id = product.id
        coupon.increment!(:used)
      end
      url = download_product_url(order.token)
      update_user_products(product.id, order.token)
      order.send_emails
      render json: { url: url, token: order.token }, status: :ok and return
    end
    render json: {error: order}, status: :unauthorized and return
  end

  def paypal
   if Rails.env.production?
     url = "https://www.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey="
   else
     url = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey="
   end

   product = Product.find(params[:product_id])
   new_price = nil
   if params[:coupon_id]
    coupon = Coupon.find params[:coupon_id]
    if coupon && coupon.active? && coupon.product.id = product.id
      new_price =  coupon.discounted_price
      coupon_id = coupon.id
    end
  end

  order = PaymentService.new('paypal').pay(product,
  {
    cancel_url: product_url(id: product.id, payment: 'failed'),
    return_url: checkout_check_payment_url(id: product.id),
    new_price: new_price,
    coupon_id: coupon_id || nil
    })

  if order
    render json: { url:  url + order.gateway_token }, status: :ok and return
  end

  render json: {}, status: :unprocessable_entity
end

def download
  order = Order.where(token: params[:token]).first
  if order.n_downloads < 5 && order.status == 'completed'
    redirect_to order.product.url
    order.increment!(:n_downloads)
    return
  end
  head(:unauthorized)
end

def unsubscribe_order_updates
  order = Order.where(token: params[:token]).first
  order.buyer_accepts_marketing = false
  order.save
  render json: {}, status: :ok
end

def ipn
  if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
    order = Order.find_by_gateway_token(params["pay_key"])
    if order && order.status != 'refunded' && params["status"].downcase == "completed"
      order.status = 'completed'
      order.email = params["sender_email"]
      order.send_emails
      if order.coupon_id
        Coupon.find(order.coupon_id).increment!(:used)
      end
      head(:ok) if order.save
    end
  end

end

def check_paypal_payment
 tries ||= 5
 if payment_completed?(params[:payKey])
  redirect_to download_url(params[:payKey])
  return
else
  5.times do
    sleep(2)
    if payment_completed?(params[:payKey])
      redirect_to download_url(params[:payKey])
      return
    end
  end
  Rails.logger.error "Paypal Error after buy from #{request.remote_ip} - paykey: #{params[:payKey]}"
  UserMailer.paypal_error_email(params[:payKey], request.remote_ip)

  render 'paypal_error', layout: false
end
end

def download_url(pay_key)
  order = Order.find_by(gateway_token: pay_key)
  product = Product.find(order.product_id)
  return product_slug_url(slug: product.slug, payKey: pay_key)
end

def payment_completed?(pay_key)
 order = Order.find_by_gateway_token(pay_key)
 if order and order.status == 'completed'
   return true
 end
 return false
end

def update_user_products(product_id, token)
  session[:user_products] ||= {}
  session[:user_products][product_id] = token
end

def is_user_product?(product_id)
  return true if session[:user_products] and
  session[:user_products].key? product_id
end
end