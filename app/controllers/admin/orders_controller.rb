class Admin::OrdersController < Admin::BaseController

  def index
    @orders = Order.all.page(params[:page]).per(8)
  end

end
