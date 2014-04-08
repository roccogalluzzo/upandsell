class User::SettingsController < User::BaseController

  def account
    @user = current_user
  end

  def update_account
    @user = current_user
    s_params = user_params
    resp = @user.update_without_password(s_params)
    if resp
     redirect_to user_settings_account_path, notice: 'Account Updated'
   else
    render 'account'
  end
end

def update_password
  s_params = user_params
  resp = @user.update_with_password(user_params)
  sign_in @user, :bypass => true
  if resp
   redirect_to user_settings_account_path, notice: 'Account Updated'
 else
  render 'account'
end

end

def payments
   #set payment options
   @user = current_user
   if params[:code]
     #redirect from paymill site
     response = access_token(params[:code])
     @user.add_credit_card(response)
     @user = current_user
   end
   unless @user.credit_card
     @paymill_url = auth_url
   end
 end

 def update_payments
  if params[:type] == 'paypal' && current_user.paypal_email
    current_user.update_without_password(paypal: params[:value])
  end
  if params[:type] == 'paymill' && current_user.credit_card_token
    current_user.update_without_password(credit_card: params[:value])
  end
  render json: {msg: 'success'}
end

def paymill_callback

end

def paymill_refresh
 @user = current_user
 refresh_token(@user.settings[:gateway_info]["refresh_token"])
 redirect_to user_settings_payments_path, notice: 'Paymill token updated'
end

def add_paypal
 api = PayPal::SDK::Permissions::API.new
 request_permissions = api.build_request_permissions({
  :scope => ["REFUND", "ACCESS_BASIC_PERSONAL_DATA"],
  :callback => user_settings_add_paypal_callback_url })
 response = api.request_permissions(request_permissions)
 if response.success?
   redirect_to api.grant_permission_url(response)
 else
  redirect_to user_settings_payments_path, warning: 'Error during request processing. Try Again'
end
end

def add_paypal_callback
  complete = false
  api = PayPal::SDK::Permissions::API.new
  get_access_token = api.build_get_access_token(
    token: params["request_token"], verifier: params["verification_code"])
  access = api.get_access_token(get_access_token)

  if access.success?
    s_api = PayPal::SDK::Permissions::API.new({
     token: access.token.to_s,
     token_secret: access.tokenSecret.to_s })

    payer_id_call = s_api.get_basic_personal_data({
      :attributeList => {
        :attribute => [ "https://www.paypal.com/webapps/auth/schema/payerID" ] } })
    payer_id = payer_id_call.response.personalData[0].personalDataValue.to_s
    complete = current_user.add_paypal_refund(payer_id, access.token, access.token_secret)

  end
  if complete
   redirect_to user_settings_payments_path, notice: 'Paypal Refund Abilitated'
 else
   redirect_to user_settings_payments_path, warning: 'Error during request processing. Try Again'
 end
end


private
def auth_url
  config =  Upandsell::Application.config.paymill
  query = {
    client_id: config[:client_id],
    scope: config[:scope],
    response_type: 'code'
    }.to_query

    URI::HTTPS.build(host: 'connect.paymill.com',
      path: '/en-gb/authorize', query: query).to_s
  end
  def refresh_token(refresh_token)
   config = Upandsell::Application.config.paymill

   body = {
    client_id: config[:client_id],
    client_secret: config[:client_secret],
    grant_type: "refresh_token",
    refresh_token: refresh_token,
    scope:  config[:scope]
    }.to_query
  end

  def access_token(auth_code)
    config = Upandsell::Application.config.paymill

    body = {
      client_id: config[:client_id],
      client_secret: config[:client_secret],
      grant_type: "authorization_code",
      code: auth_code
      }.to_query

      uri = URI::HTTPS.build(host: 'connect.paymill.com',
        path: '/token')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body =  body
      res = ActiveSupport::JSON.decode(http.request(request).body)
      return res
    end

    def payment_params
      params.require(:user).permit(:credit_card, :paypal)
    end

    def user_params
      params.require(:user).permit( :email, :name, :currency, :current_password, :password,
        :password_confirmation)
    end
 # TODO activate/deactivate newsletter weekly report
end
