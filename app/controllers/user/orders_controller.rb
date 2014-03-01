class User::OrdersController < User::BaseController
  include PayPal::SDK::AdaptivePayments
def index
@orders = Order.where(product_id:
  Customer.find(current_customer.id).products.ids, status: 'completed')
.page(params[:page]).per(8)

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
