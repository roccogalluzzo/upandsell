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

  def paypal_connect
    redirect_to Gateways::Paypal.connect_url(paypal_integration_callback_url) and return
  end

  def paymill_callback
    if current_user.connect_credit_card(auth_hash)
      redirect_to edit_user_settings_payments_path, notice: 'Gateway Connected' and return
    end
    redirect_to edit_user_settings_payments_path, alert: 'Error during request processing. Try Again'
  end

  def paypal_callback
    if Gateways::Paypal.connect(current_user, params["request_token"], params["verification_code"])
     redirect_to edit_user_settings_payments_path, notice: 'Gateway Connected'
   else
    redirect_to edit_user_settings_payments_path, alert: 'Error during request processing. Try Again'
  end
end

protected
def auth_hash
  request.env['omniauth.auth']
end

private
def payment_params
  params.require(:user).permit(:credit_card, :paypal)
end
end