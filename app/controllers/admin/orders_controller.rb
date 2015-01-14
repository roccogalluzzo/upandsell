class Admin::OrdersController < Admin::BaseController

  def index
    @orders = Order.completed.page(params[:page]).per(8)
  end

end
