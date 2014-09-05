class RegistrationsController < Devise::RegistrationsController

  def new
    if params[:beta_token]
      # check if is present on db
    end
    # if param not present show beta error message
    if params[:ref]
     @ref = params[:ref]
   else
    @ref = cookies[:aff_tag]
  end
  super
end

protected
def after_inactive_sign_up_path_for(resource)
  user_setup_path
end

def after_sign_up_path_for(resource)
  user_setup_path
end
end