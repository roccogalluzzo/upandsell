class User::Settings::PaymentsController < User::BaseController

  def edit
  end

  def update
    current_user.update_without_password(payment_params)
    redirect_to edit_user_settings_payments_path, alert: 'Payments Info Updated.'
  end

  def paypal_connect
    redirect_to Gateways::Paypal.connect_url(paypal_integration_callback_url) and return
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
  params.require(:user).permit(
    :credit_card, :paypal,
    :credit_card_gateway,
    :credit_card_public_token,
    :credit_card_token )
end
end