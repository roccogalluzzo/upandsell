class ProductsController < ApplicationController
  layout "product"
  include PayPal::SDK::AdaptivePayments
  skip_before_filter :verify_authenticity_token, :only => [:ipn]

  def paypal
    @product = Product.find(params[:product_id])
    @customer  = Customer.find(@product.customer_id)
   #Paypal logic
   paypal = PayPal::SDK::AdaptivePayments.new
   req = paypal.BuildPay(
     :actionType => 'CREATE',
     :receiverList => {'receiver' =>
      [{'email' => @customer.email,
       'amount' => @product.price
       }]
       },
       :cancelUrl => product_url(id: @product.id, payment: 'failed'),
       :returnUrl =>  products_check_payment_url(id: @product.id) +'&payKey=${payKey}',
       :ipnNotificationUrl =>
        if Rails.env.production?
         products_ipn_url()
      else
       'http://upandsell.ngrok.com/products/ipn'
     end,
     :currencyCode => @product.price_currency.upcase
     )
   @response = paypal.pay(req)
   if @response.success?
    @payment= @product.payment.build(:paykey => @response.payKey,
      :date => @response.responseEnvelope.timestamp,
      :completed => false,
      :amount => @product.price )
    @payment.customer_id = @product.customer_id
    @payment.save
    status = 'ok'
  end
  url = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey="
  render json: { status: status, url:  url + @response.payKey }
end

def download
  @payment = Payment.find_by token: params[:token]
  if @payment.n_downloads < 5
    @payment.increment!(:n_downloads)
    redirect_to @payment.product.expiring_url
    #head(:bad_request) and return unless File.exist?(path)
   # send_file(path, :filename => @payment.product.file.instance.file_file_name)
  end

  #TODO error message if number of mak downloads if espired
end
def show
  if params[:payKey]
    @payment = Payment.find_by paykey: params[:payKey]
    if @payment.completed
      session[:user_products] ||= {}
      session[:user_products][@payment.product.id] = @payment.token
    end
  end
  @product = Product.find_by slug: params[:slug]
end

def ipn
  if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
    payment = Payment.find_by paykey: params["pay_key"]
    if params["status"] == "COMPLETED"
      payment.completed = true
      payment.token = SecureRandom.urlsafe_base64(16);
      payment.save
    end

  end
  render :nothing => true

end

def check_paypal_payment
 @payment = Payment.find_by paykey: params[:payKey]
 if @payment.completed
  status = 'ok'
  url = product_slug_url(slug: @payment.product.slug, payKey: params[:payKey])
end
payKey = params[:payKey]
 respond_to do |format|
      format.html {redirect_to url if status=='ok'}
      format.json { render json: { status: status, url: url} }
    end
end

end
