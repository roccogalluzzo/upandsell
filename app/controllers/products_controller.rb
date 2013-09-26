class ProductsController < ApplicationController
include PayPal::SDK::AdaptivePayments
#include PayPal::SDK::AdaptivePayments::Urls

 def buy
   @product = Product.find(params[:id])
   @customer  = Customer.find(2)#@product.customer_id)
   #Paypal logic
   paypal = PayPal::SDK::AdaptivePayments.new
   req = paypal.BuildPay(
   :actionType => 'CREATE',
   :receiverList => {'receiver' => 
      [{'email' => @customer.email,
         'amount' => @product.price
       }]
    },
    :cancelUrl => 'http://localhost:3000/product/fail',
    :returnUrl => 'http://localhost:3000/products/success',
    :ipnNotificationUrl => 'https://6e1d19bd.ngrok.com/products/ipn',
    :currencyCode => 'USD'
    )
   @pay_response = paypal.pay(req)
  print @pay_response.paymentExecStatus
   if @pay_response.success?
   redirect_to paypal.pay_url(@pay_response.payKey)
 # redirect_to @pay_response.approve_paypal_payment_url
end

    # render :nothing => true

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
