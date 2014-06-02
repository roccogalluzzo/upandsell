class RegistrationsController < Devise::RegistrationsController


  def new
    if params[:ref]
     @ref = params[:ref]
   else
    @ref = cookies[:aff_tag]
  end

  super
end

protected
def after_inactive_sign_up_path_for(resource)
  user_settings_setup_path
end

def configure_permitted_parameters
  devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password,
    :password_confirmation, :name, :referer_id) }
end

def after_sign_up_path_for(resource)
  user_settings_setup_path
end
end