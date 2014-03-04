class ProductsController < ApplicationController
  layout "product"
  include PayPal::SDK::AdaptivePayments
  skip_before_filter :verify_authenticity_token, :only => [:ipn]

  def pay_info
    @product = Product.find(params[:product_id])
    render json: { price: @product.price.cents, currency: @product.price_currency.upcase }

  end

  def pay
   @product = Product.find(params[:product_id])
   @user  = User.find(@product.user_id)
   Paymill.api_key = @user.credit_card_token

   payment = Paymill::Payment.create(token: params[:token])
Rails.logger.info payment
   pay = Paymill::Transaction.create(amount: @product.price.cents,
   currency: @product.price_currency.upcase, payment: payment.id)

   if pay.status == 'closed' && params[:email].present?
    order = @product.orders.build(
      email: params[:email],
      payment_type: 'paymill',
      payment_token: pay.id,
      status: 'completed',
      amount_cents: @product.price.cents,
      amount_currency: @product.price.currency,
      )
    order.save
    url = download_product_url(order.token)
    update_user_products(order.product.id, order.token)
    render json: { status: 'completed', url: url }
    return
  else
    render json: { status: 'failed'}
  end
end

def paypal
  @product = Product.find(params[:product_id])
  @user  = User.find(@product.user_id)
   #Paypal logic
   paypal = PayPal::SDK::AdaptivePayments.new
   req = paypal.BuildPay(
     :actionType => 'CREATE',
     :receiverList => {'receiver' =>
      [{'email' => @user.email,
       'amount' => @product.price
       }]
       },
       :cancelUrl => product_url(id: @product.id, payment: 'failed'),
       :returnUrl =>  products_check_payment_url(id: @product.id) +'&payKey=${payKey}',
       :ipnNotificationUrl =>
       if Rails.env.production?
         'https://upandsell.me/products/ipn'
       else
         'http://upandsell.ngrok.com/products/ipn'
       end,
       :currencyCode => @product.price_currency.upcase
       )
   @response = paypal.pay(req)
   if @response.success?
    @order= @product.orders.build(
      payment_type: 'paypal',
      payment_token: @response.payKey,
      status: 'created',
      amount_cents: @product.price,
      amount_currency: @product.price_currency.upcase
      )
    @order.product_id = @product.id
    @order.save
    status = 'ok'
      url = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey="
  render json: { status: status, url:  url + @response.payKey }
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
  @paypal = @product.user.paypal_status
  @credit_card =  @product.user.credit_card_status
  if request.browser?
    Metric::Products.new(@product.id).incr_visits
  end
end

def ipn
  if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
    order = Order.find_by payment_token: params["pay_key"]
    if params["status"] == "COMPLETED"
      order.status = 'completed'
      order.save
    end

  end
  render :nothing => true

end

def check_paypal_payment
 @order = Order.find_by payment_token: params[:payKey]
 if @order.completed
  status = 'ok'
  url = product_slug_url(slug: @order.product.slug, payKey: params[:payKey])
end
payKey = params[:payKey]
respond_to do |format|
  format.html {redirect_to url if status=='ok'}
  format.json { render json: { status: status, url: url} }
end
end

private
def downadable?

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
