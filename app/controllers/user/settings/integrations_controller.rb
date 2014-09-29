require 'net/http'
require 'createsend'
class User::Settings::IntegrationsController < User::BaseController

  def edit
  end

  def create
    provider = auth_hash[:provider]
    if provider == 'createsend'
      access_token = {access_token: auth_hash.credentials.token,
        refresh_token: auth_hash.credentials.refresh_token
      }
    else
      access_token = "#{auth_hash.credentials.token}-#{auth_hash.extra.metadata.dc}"
    end

    if current_user.update_attribute("#{provider}_token", access_token)
      redirect_to edit_user_settings_integrations_path
    end
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
