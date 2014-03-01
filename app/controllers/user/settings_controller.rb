class User::SettingsController < User::BaseController

  def account
    #change email, password, default currency
    @customer = current_customer
  end

  def payments
   #set payment options
   @customer = current_customer
   if params[:code]
     #redirect from paymill site
     response = access_token(params[:code])
     @customer.add_credit_card(response)
     @customer = current_customer
   end
   unless @customer.credit_card_token
     @paymill_url = auth_url
   end
 end

 def update_account
  @customer = Customer.find(current_customer.id)
  unless @customer.blank?
    params[:customer].delete(:password) if params[:customer][:password].blank?
    params[:customer].delete(:password_confirmation) if params[:customer][:password_confirmation].blank?

    if @customer.update_account(customer_params)
      # Sign in the user bypassing validation in case his password changed
      sign_in @customer, :bypass => true
      redirect_to user_settings_account_path, notice: 'Account Updated'
    else
      render 'account'
    end
  end
end
def update_payments
 @customer = Customer.find(current_customer.id)

 unless @customer.blank?
   @customer.update_without_password(params[:customer]
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
def customer_params
  params.require(:customer).permit( :email, :password,
    :password_confirmation)
end
 # TODO activate/deactivate newsletter weekly report
end
