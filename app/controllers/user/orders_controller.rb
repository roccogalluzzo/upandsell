class User::OrdersController < User::BaseController
  include PayPal::SDK::AdaptivePayments
  def index
    @orders = Order.where(product_id:
      User.find(current_user.id).products.ids, status: 'completed')
    .page(params[:page]).per(8)

  end

  def refund
    @order = Order.find(params[:id])

    if @order.payment_type == 'paypal' and current_user.paypal_token
     paypal = PayPal::SDK::AdaptivePayments.new
     response = paypal.Refund( payKey: @order.payment_token)
     if response.success?
      @order.update_attributes(status: 'refunded')
      redirect_to user_orders_path, notice: 'Payment Refunded'
      return
    else
     redirect_to user_orders_path, notice: 'Error, try from Paypal panel.'
     return
   end
 else
  Paymill.api_key =  current_user.credit_card_token
  response =  Paymill::Refund.create id: @order.payment_token,
  amount: @order.amount_cents
  @order.update_attributes(status: response.status)
  redirect_to user_orders_path, notice: 'Payment Refunded'
  return
end
end

end
