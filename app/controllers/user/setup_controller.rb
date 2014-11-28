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
      current_user.attributes = billing_params.except(:cc_number, :cc_expire, :cc_cvc)
      if current_user.save
        SubscriptionService.subscribe(user, params[:stripe_token])
      end
  end
end

  private
  def billing_info_valid?
    eu_countries= ['AT', 'BE', 'BG', 'CY', 'DK', 'EE', 'FI', 'FR', 'DE', 'GR', 'IE', 'IT', 'LV', 'LT', 'LU', 'MT', 'NL', 'PL', 'PT', 'GB', 'CZ', 'RO', 'SK', 'SI', 'ES', 'SE', 'HU']

    info = billing_params
    [:business_type, :country, :legal_name, :address, :zip_code, :city, :province, :cc_number, :cc_expire, :cc_cvc].each do | e |
      return false if info[e].blank?
    end

    if info[:country] == 'IT' && info[:tax_code].blank?
      return false
    end

    if eu_countries.include?(info[:country]) && info[:business_type] == 'company'  && info[:tax_code].blank?
      return false
    end
  end

  private
  def billing_params
    params.require(:user).permit(:business_type, :country, :legal_name,   :tax_code, :address, :zip_code, :city, :province, :cc_number, :cc_expire, :cc_cvc)
  end
end
