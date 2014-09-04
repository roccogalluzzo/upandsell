class Admin::UsersController < Admin::BaseController

  def index
    @users = User.all.page(params[:page]).per(8)
  end

end