class ConfirmationsController < Devise::ConfirmationsController

  private
  def after_confirmation_path_for(resource_name, resource)
    user_settings_setup_path
  end

  private
  def after_inactive_sign_up_path_for(resource)
    user_settings_setup_path
  end
end
