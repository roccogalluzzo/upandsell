class ConfirmationsController < Devise::ConfirmationsController
  skip_after_filter :intercom_rails_auto_include
  private
  def after_confirmation_path_for(resource_name, resource)
    user_setup_path
  end

end
