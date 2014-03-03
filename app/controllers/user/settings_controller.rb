class User::SettingsController < User::BaseController

  def account
    #change email, password, default currency
    @user = current_user
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
   unless @user.credit_card_token
     @paymill_url = auth_url
   end
 end

 def update_account
  @user = User.find(current_user.id)
  unless @user.blank?
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?

    if @user.update_account(user_params)
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to user_settings_account_path, notice: 'Account Updated'
    else
      render 'account'
    end
  end
end
def update_payments
 @user = User.find(current_user.id)

 unless @user.blank?
   @user.update_without_password(params[:user]
    .permit(:credit_card_status, :paypal_status, :email_paypal))
 end
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
          path: '/authorize', query: query).to_s
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
def user_params
  params.require(:user).permit( :email, :password,
    :password_confirmation)
end
 # TODO activate/deactivate newsletter weekly report
end
