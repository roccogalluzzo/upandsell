class User::SetupController < User::BaseController

  def index
    @email = current_user.confirmed?
    @payments = true if current_user.paypal || current_user.credit_card
    unless current_user.credit_card
     @paymill_url = auth_url
   end
 end

 def resend_email
  current_user.send_confirmation_instructions
  render json: {status: 200}
end

def update_email
  @user = current_user
  s_params = user_params
  resp = @user.update_without_password(s_params)
  if resp
    current_user.send_confirmation_instructions
    render json: {status: 200}
  else
    render json: {status: 500}
  end
end
end