class User::SettingsController < User::BaseController

  def account
    #change email, password, default currency
    @user = current_user
  end

  def update_account
    @user = current_user
    s_params = user_params
    if s_params[:password].blank?
      s_params.delete("current_password")
      s_params.delete("password")
      s_params.delete("password_confirmation")
      resp = @user.update_without_password(s_params)
    else
      resp = @user.update_with_password(user_params)
      sign_in @user, :bypass => true
    end
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
   unless @user.credit_card_status
     @paymill_url = auth_url
   end
 end

 def update_payments
   @user = current_user
   s_params = payment_params
   unless @user.credit_card_token
    s_params[:credit_card_status] = false
  end
  unless s_params[:paypal_email].present?
    s_params[:paypal_status] = false
  end
   @user.update_without_password(s_params)

   redirect_to user_settings_payments_path, notice: 'Account Updated'
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
      params.require(:user).permit(:credit_card_status, :paypal_status, :paypal_email)
    end

    def user_params
      params.require(:user).permit( :email, :name, :currency, :current_password, :password,
        :password_confirmation)
    end
 # TODO activate/deactivate newsletter weekly report
end
