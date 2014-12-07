class User::Settings::BillingsController < User::BaseController

  def new
    @method = :post
  end

  def create
    @success = false
    if billing_info_valid?
      current_user.attributes = billing_params
      if SubscriptionService.new(current_user).subscribe
        #render json: {}, status: :ok and return
        @success = true
      end
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
    @method = :put
  end

  def update
    if billing_info_valid?
      current_user.attributes = billing_params
        sub = SubscriptionService.new(current_user)
        if current_user.stripe_token_changed? &&  current_user.plan_type_changed?
          success = sub.subscribe
        elsif current_user.stripe_token_changed?
          success = sub.update_card
        elsif  current_user.plan_type_changed?
        success = sub.update_subscription
        end
        if success
          render json: {}, status: :ok and return
        end
      end

    render json: {error: current_user.errors.full_messages}, status: :unprocessable_entity
  end

  def destroy
    SubscriptionService.new(current_user).unsubscribe
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
