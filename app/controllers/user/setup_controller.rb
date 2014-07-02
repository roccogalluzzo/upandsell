class User::SetupController < User::BaseController

  def index
    @email = current_user.confirmed?
    @payments = true if current_user.paypal || current_user.credit_card
  end

  def resend_email
    current_user.send_confirmation_instructions
    render json: {}, status: :ok and return
  end

  def update_email
    if current_user.update_without_password(email: params[:user][:email])
      current_user.send_confirmation_instructions
      render json: {}, status: :ok and return
    end
    render json: {}, status: :unprocessable_entity
  end
end