class User::OrdersController < User::BaseController

  def index
    @orders = current_user.orders.completed.page(params[:page]).per(8)

  end

  def refund
    @order = Order.find(params[:id])
    if @order.user_id == current_user.id && @order.refund
      redirect_to user_orders_path, notice: 'Payment Refunded'
    else
     redirect_to user_orders_path, notice: 'Error, try from Gateway panel.'
     return
   end
 end
end
