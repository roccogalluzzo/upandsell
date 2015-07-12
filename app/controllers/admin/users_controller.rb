class Admin::UsersController < Admin::BaseController
  include SignInAs

  def index
    @users = User.all.page(params[:page]).per(15)
  end

  def switch
   sign_in :user, User.find(params[:user_id])
   self.remember_admin_id(current_user.id)
   redirect_to user_root_path
 end

end