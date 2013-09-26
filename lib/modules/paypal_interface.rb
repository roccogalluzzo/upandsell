require 'paypal-sdk-adaptivepayments'
class PaypalInterface
  include PayPal::SDK::AdaptivePayments::Urls
  attr_reader :api, :express_checkout_response

  #PAYPAL_RETURN_URL = Rails.application.routes.url_helpers.paid_orders_url(host: HOST_WO_HTTP)
  #PAYPAL_CANCEL_URL = Rails.application.routes.url_helpers.revoked_orders_url(host: HOST_WO_HTTP)
  #PAYPAL_NOTIFY_URL = Rails.application.routes.url_helpers.ipn_orders_url(host: HOST_WO_HTTP)

  def initialize(product)
    @api = PayPal::SDK::AdaptivePayments.new
    @product = product
  end

  def make_payment
   customer  = Customer.find(2)#@product.customer_id)
   #Paypal logic
   req = @api.BuildPay(
   :actionType => 'CREATE',
   :receiverList => {'receiver' => 
      [{'email' => customer.email,
         'amount' => @product.price
       }]
    },
    :cancelUrl => 'http://localhost:3000/product/fail',
    :returnUrl => 'http://localhost:3000/product/success',
    :currencyCode => 'USD'
    )
   @pay_response = @api.pay(req)
   PaypalHelper.pay_url
  print @pay_response.paymentExecStatus
   if @pay_response.success?
   print @urls.pay_url
 # redirect_to @pay_response.approve_paypal_payment_url
end

    # render :nothing => true

 end
end