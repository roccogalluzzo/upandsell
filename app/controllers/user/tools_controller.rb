class User::ToolsController < User::BaseController

  def index
    @orders = current_user.orders.completed.page(params[:page]).per(8)

  end

  def newsletter
  end
end
