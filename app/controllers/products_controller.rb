class ProductsController < ApplicationController
  include PayPal::SDK::AdaptivePayments
#include PayPal::SDK::AdaptivePayments::Urls

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
       :returnUrl => 'http://localhost:3000/products/success',
  #  :ipnNotificationUrl => 'https://6e1d19bd.ngrok.com/products/ipn',
  :currencyCode => 'USD'
  )
   @response = paypal.pay(req)
   if @response.success?
    redirect_to paypal.pay_url(@response.payKey)
    @payment= @product.payment.build(:paykey => @response.payKey, 
                            :date => @response.responseEnvelope.timestamp,
                            :completed => false,
                            :amount => @product.price )
    @payment.customer_id = @product.customer_id
    @payment.save
  end

end

def ipn
  if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
    logger.info("IPN message: VERIFIED")
    render :text => "VERIFIED"
  else
    logger.info("IPN message: INVALID")
    render :text => "INVALID"
  end
end

def success
  print params
  render :nothing => true
end


end
