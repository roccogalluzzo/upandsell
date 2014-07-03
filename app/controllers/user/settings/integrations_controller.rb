require 'net/http'
require 'createsend'
class User::Settings::IntegrationsController < User::BaseController

  def edit
  end

  def create
    provider = auth_hash[:provider]
    if provider == 'createsend'
      access_token = auth_hash.credentials.token
    else
      access_token = request_token(provider, params[:code])
    end

    if current_user.update_attribute("#{provider}_token", access_token)
      redirect_to edit_user_settings_integrations_path
    end
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def request_token(provider, code)
    urls = {mailchimp: 'https://login.mailchimp.com/oauth2/token',
      createsend: 'https://api.createsend.com/oauth/token'}
      body = {
       grant_type: 'authorization_code',
       client_id:  Rails.application.secrets[provider]['client_id'],
       client_secret:  Rails.application.secrets[provider]['client_secret'],
       redirect_uri: integration_callback_url(provider),
       code: code
       }.to_query
       uri = URI.parse(urls[provider.to_sym])
       http = Net::HTTP.new(uri.host, uri.port)
       http.use_ssl = true
       request = Net::HTTP::Post.new(uri.request_uri)
       request.body =  body
       ActiveSupport::JSON.decode(http.request(request).body)['access_token']
     end
   end