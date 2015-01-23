class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout 'site'
  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(user)
    if user.subscription_active
     user_root_path
   elsif !user.legal_name && !user.subscription_active && !user.address
     user_complete_signup_path
   else
    edit_user_settings_billing_path
  end
end

protected
def configure_permitted_parameters
  devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email,
    :password, :password_confirmation, :referer_id) }
end

end
