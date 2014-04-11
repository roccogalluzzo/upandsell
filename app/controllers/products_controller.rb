class ProductsController < ApplicationController
  layout "product"
  skip_before_filter :verify_authenticity_token, :only => [:ipn]

  def pay_info
    @product = Product.find(params[:product_id])
    render json: { price: @product.price.cents, currency: @product.price_currency.upcase }

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
     render json: { status: 'completed', url: url }
     return
   else
    render json: { status: 'failed', error: pay.response_code}
  end
end

def paypal
  product = Product.find(params[:product_id])
  user  = product.user
  response = product.pay('paypal')

  order = product.orders.build(
    payment_type: 'paypal',
    payment_token: response.payKey,
    status: 'created',
    cc_type: 'paypal',
    amount_cents: product.price.cents,
    amount_currency: product.price_currency.upcase
    )

  if response.success? and order.save
    status = 'ok'
    url = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey="
    render json: { status: status, url:  url + response.payKey }
    return
  else
   render json: { status: 'fail'}
 end
end

def download
  @order = Order.find_by token: params[:token]

  if @order.n_downloads < 5 && @order.status == 'completed'
    redirect_to @order.product.expiring_url
    @order.increment!(:n_downloads)
    return
    #head(:bad_request) and return unless File.exist?(path)
   # send_file(path, :filename => @payment.product.file.instance.file_file_name)
 end
 render json: { status: "no more donwload permitted"}
end

def show
  if params[:payKey]
    @order = Order.find_by  payment_token: params[:payKey]
    if @order.status = 'completed'
      update_user_products(@order.product.id, @order.token)
      @downloads =  @order.n_downloads
    end
  end
  @product = Product.find_by slug: params[:slug]
  if !@downloads and is_user_product?(@product.id)
    @order = Order.find_by token: session[:user_products][@product.id]
    if @order.present? && @order.status == 'completed'
      @downloads =  @order.n_downloads
    end
  end
  @paypal = @product.user.paypal
  @credit_card = @product.user.credit_card
  Rails.logger.info @product.user.paypal
  ua = AgentOrange::UserAgent.new(request.env['HTTP_USER_AGENT'])
  unless ua.is_bot?
    Metric::Products.new(@product.id).incr_visits
  end
end

def ipn
  if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
    order = Order.find_by payment_token: params["pay_key"]
    if order and params["status"] == "COMPLETED"
      order.status = 'completed'
      order.email = params["sender_email"]
      if order.save
       user  = User.find(order.product.user_id)
       UserMailer.bought_email(user, order).deliver
       UserMailer.sold_email(user, order).deliver
     end
   end

 end
 render :nothing => true

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
  render nothing: true
end
end


private
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
