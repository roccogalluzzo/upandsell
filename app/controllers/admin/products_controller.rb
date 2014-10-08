class Admin::ProductsController < Admin::BaseController

  def index
    @products = Product.all.page(params[:page]).per(8)
  end

end
