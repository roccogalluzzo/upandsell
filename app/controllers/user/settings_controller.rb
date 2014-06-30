class User::SettingsController < User::BaseController

  def account
  end

  def upgrade
  end

  def payments
  end

  def emails
  end
  def integrations
  end

  def update_account
    par = user_params
    if !user_params[:current_password].blank?
      r = current_user.update_with_password(user_params)
      if r
       sign_in current_user, bypass: true
       redirect_to user_settings_account_path, notice: 'Account Updated' and return
     end
   else
    par.delete(:current_password)
    current_user.update_without_password(par)
    redirect_to user_settings_account_path, notice: 'Account Updated' and return
  end
  render 'account'
end

def connect
  if params[:gateway] == 'paypal'
    redirect_to Gateways::Paypal.connect_url(
      user_settings_connect_callback_url(gateway: 'paypal')) and return
  elsif params[:gateway] == 'paymill'
    redirect_to Gateways::Paymill.connect_url and return
  end
  redirect_to user_settings_payments_path, warning: 'Error during request processing. Try Again'
end

def connect_callback

 if params[:gateway] == 'paypal'
  response = Gateways::Paypal.connect(current_user,
    params["request_token"], params["verification_code"])
elsif params[:gateway] == 'paymill'
  response = Gateways::Paymill.connect(current_user, params["code"])
end

if response
 redirect_to user_settings_payments_path, notice: 'Gateway Connected'
else
  redirect_to user_settings_payments_path, alert: 'Error during request processing. Try Again'
end
end

def save_upgrade
  response = Gateways::Paymill.subscribe(params[:token])
  if response.success?
   current_user.update_attribute(account: 'pro')
   if current_user.referer_id
    Referral.new(referer_id: current_user.referer_id, user_id: current_user.id,
      amount: 1500, status: 'pending')
  end
end
render json: {response: response}
end

def update_emails

  if user

  else
    render 'password'
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


private
def payment_params
  params.require(:user).permit(:credit_card, :paypal)
end

def user_params
  params.require(:user).permit( :email, :name, :email_after_sale, :ga_code,
   :currency, :current_password, :password,
   :password_confirmation)
end
 # TODO activate/deactivate newsletter weekly report
end
