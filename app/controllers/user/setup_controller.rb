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

  def billing_details
  end

  def save_billing_details
    if billing_info_valid?
      current_user.attributes = billing_params.except(:stripe_token, :plan_type)
      if current_user.save && SubscriptionService.new(current_user).subscribe(params[:user][:stripe_token], params[:user][:plan_type].to_sym)
        render json: {url: user_setup_path}, status: :ok and return
      end
  end

  render json: {error: current_user.errors.full_messages}, status: :unprocessable_entity
end

  private
  def billing_info_valid?
    eu_countries= ['AT', 'BE', 'BG', 'CY', 'DK', 'EE', 'FI', 'FR', 'DE', 'GR', 'IE', 'IT', 'LV', 'LT', 'LU', 'MT', 'NL', 'PL', 'PT', 'GB', 'CZ', 'RO', 'SK', 'SI', 'ES', 'SE', 'HU']

    info = billing_params

    [:stripe_token, :plan_type, :business_type, :country, :legal_name, :address,
      :zip_code, :city, :province].each do | e |
      return false if info[e].blank?
    end

    if info[:country] == 'IT' && info[:tax_code].blank?
      return false
    end

    if eu_countries.include?(info[:country]) && info[:business_type] == 'company'  && info[:tax_code].blank?
      return false
    end
    true
  end

  private
  def billing_params
    params.require(:user).permit(:stripe_token, :plan_type, :business_type, :country, :legal_name, :tax_code, :address, :zip_code, :city, :province)
  end
end
