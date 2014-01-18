class ProductsController < ApplicationController
  include PayPal::SDK::AdaptivePayments
  skip_before_filter :verify_authenticity_token, :only => [:ipn]

  def buy
    @product = Product.find(params[:id])
    @customer  = Customer.find(@product.customer_id)
   #Paypal logic
   paypal = PayPal::SDK::AdaptivePayments.new
   req = paypal.BuildPay(
     :actionType => 'CREATE',
     :receiverList => {'receiver' =>
      [{'email' => @customer.email,
       'amount' => @product.price,
       :paymentType => 'DIGITALGOODS'
       }]
       },
       :cancelUrl => 'http://localhost:3000/product/fail',
       :returnUrl => 'http://localhost:3000/products/success?payKey=${payKey}',
       :ipnNotificationUrl => if Rails.env.production?
         'http://upandsell.it/dev/products/ipn'
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
  render json: { status: status, pay_key: @response.payKey}
end

def show
 @product = Product.find_by slug: params[:slug]
end

def ipn
  if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
    payment = Payment.find_by paykey: params["pay_key"]
    if params["status"] == "COMPLETED"
      payment.completed = true
      payment.save
    end

  end
  render :nothing => true

end

def success
  print params

  @payment = Payment.find_by paykey: params[:payKey]

  render layout: false
end


end
