class User::OrdersController < User::BaseController

  def index
    if params[:products] && params[:products] != '0'
      @orders = current_user.orders.where(product_id: params[:products])
    else
      @orders = current_user.orders.order('created_at desc')
    end

    if params[:q] && !params[:q].blank?
      @orders = @orders.email_starts_with(params[:q])
    end

    @orders = @orders.completed.page(params[:page]).per(8)
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
