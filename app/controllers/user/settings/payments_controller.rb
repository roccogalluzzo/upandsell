class User::Settings::PaymentsController < User::BaseController

  def edit
  end

  def update
    if params[:type] == 'paypal' && current_user.paypal_email
      current_user.update_without_password(paypal: params[:value])
    end
    if params[:type] == 'paymill' && current_user.credit_card_token
      current_user.update_without_password(credit_card: params[:value])
    end
    render json: {msg: 'success'}
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

private
def payment_params
  params.require(:user).permit(:credit_card, :paypal)
end
end