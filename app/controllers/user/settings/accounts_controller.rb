class User::Settings::AccountsController < User::BaseController

  def edit
  end

  def update
    par = user_params
    if !user_params[:current_password].blank?
      r = current_user.update_with_password(user_params)
      if r
       sign_in current_user, bypass: true
       redirect_to edit_user_settings_account_path, notice: 'Account Updated' and return
     end
   else
    par.delete(:current_password)
    current_user.update_without_password(par)
    redirect_to edit_user_settings_account_path, notice: 'Account Updated' and return
  end
  render 'account'
end

private
def user_params
  params.require(:user).permit( :email, :name, :email_after_sale, :ga_code,
   :currency, :current_password, :password,
   :password_confirmation)
end
end