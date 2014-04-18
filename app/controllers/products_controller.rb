class ProductsController < ApplicationController
  layout "product"
  skip_before_filter :verify_authenticity_token, :only => [:ipn]

  def pay_info
    product = Product.find(params[:product_id])
    render json: { price: product.price.cents,
     currency: product.price_currency.upcase
   }
 end

 def pay
  product = Product.find(params[:product_id])
  user  = product.user
  pay = product.pay('paymill', params[:token])
  order = product.orders.build(
    email: params[:email],
    payment_type: 'paymill',
    payment_token: pay.id,
    status: 'completed',
    amount: product.price,
    cc_type: pay.payment["card_type"])

  if pay.status == 'closed' && params[:email].present? && order.save
    url = download_product_url(order.token)
    update_user_products(order.product.id, order.token)
    render json: { url: url }, status: :ok
  else
    render json: {error: pay.response_code}, status: :unauthorized
  end
end

def paypal
  url = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey="
  product = Product.find(params[:product_id])
  user  = product.user
  response = product.pay('paypal',
    product_url(id: product.id, payment: 'failed'),
    products_check_payment_url(id: product.id))

  order = product.orders.build(
    payment_type: 'paypal',
    payment_token: response.payKey,
    status: 'created',
    cc_type: 'paypal',
    amount_cents: product.price.cents,
    amount_currency: product.price_currency.upcase)

  if response.success? and order.save
    render json: { url:  url + response.payKey }, status: :ok and return
  end

  render json: {}, status: :unprocessable_entity
end

def download
  @order = Order.find_by token: params[:token]
  if @order.n_downloads < 5 && @order.status == 'completed'
    redirect_to @order.product.expiring_url
    @order.increment!(:n_downloads)
    return
  end
  head(:unauthorized)
end

def show
  @product = Product.find_by! slug: params[:slug]
  (render(status: :not_found) and return) if !@product.present?
  @title = @product.name
  register_visit(@product)
  @paypal = @product.user.paypal
  @credit_card = @product.user.credit_card
  @published = true if (@paypal || @credit_card) && @product.published
  @action = @credit_card ? 'buy': 'buyPaypal'
  @downloadable = false
 #registra pagamento paypal se presente
 if params[:payKey]
  order = Order.find_by  payment_token: params[:payKey]
  if order.status == 'completed' && order.product.id == @product.id
    update_user_products(order.product.id, order.token)
    @downloads =  order.n_downloads
    @action = 'afterPaypal'
    @downloadable = true if (@downloads < 5)
    @token = order.token
    return
  end

end

#check sessione se il prodotto risulta gia' acquistato
if is_user_product?(@product.id)
  order = Order.find_by token: session[:user_products][@product.id]
  if order.present? && order.status == 'completed'
    @downloads =  order.n_downloads
    @action = 'download' if (@downloads < 5)
    @downloadable = true if (@downloads < 5)
    @token = order.token
  end
end
end

def ipn
  if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
    order = Order.find_by payment_token: params["pay_key"]
    if order && order.status != 'refunded' && params["status"].downcase == "completed"
      order.status = 'completed'
      order.email = params["sender_email"]
      order.save
    end

  end
  render nothing: true

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
  @title = "Paypal Error"
  render 'paypal_error'
end
end


private
def register_visit(product)
  ua = AgentOrange::UserAgent.new(request.env['HTTP_USER_AGENT'])
  unless ua.is_bot?
    Metric::Products.new(product.id).incr_visits
  end
end

def download_url(pay_key)
  order = Order.find_by payment_token: pay_key
  return product_slug_url(slug: order.product.slug, payKey: pay_key)
end

def payment_completed?(pay_key)
 order = Order.find_by payment_token: pay_key
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
