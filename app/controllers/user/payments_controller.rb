class User::PaymentsController < User::BaseController
  include PayPal::SDK::AdaptivePayments
def index
@payments= Customer.find(current_customer.id).payment
.where(completed: true)

end

def refund
  @payment = Payment.find(params[:id])
   #Paypal logic
   paypal = PayPal::SDK::AdaptivePayments.new
   response = paypal.Refund( :payKey => @payment.paykey)

   print response
    render json: { pay_key: response}
end
end
