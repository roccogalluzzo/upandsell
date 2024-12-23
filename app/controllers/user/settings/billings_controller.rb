class User::Settings::BillingsController < User::BaseController
  layout 'complete_signup', only: [:new]

  def invoice
    @invoice = SubscriptionInvoice.find params[:id]
    return false unless @invoice.finalized?
    unless current_user.admin? || (@invoice.user_id == current_user.id)
      return false
    end
    @stripe =  Stripe::Invoice.retrieve(@invoice.stripe_id)
    respond_to do |format|
      format.pdf do
        render :pdf => "invoice"
      end
    end
  end

  def new
    @method = :post

    @month_price = 24.99.in(:eur).to(:usd).to_s(:plain)
    @year_price =  249.99.in(:eur).to(:usd).to_s(:plain)

  end

  def create
    @success = false
    if billing_info_valid?
      current_user.attributes = billing_params
      if current_user.create_subscription
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
    @month_price = 24.99.in(:eur).to(:usd).to_s(:plain)
    @year_price =  249.99.in(:eur).to(:usd).to_s(:plain)
    @invoices =  current_user.subscription_invoices.finalized
  end

  def apply_coupon
    if params[:coupon][:code].upcase == 'CIAO'
      if current_user.apply_coupon('CIAO')
        render json: {
          message: '<span><b>CIAO</b> - <span class="text-muted">3 months FREE</span></span>',
          trial_end: current_user.subscription_end.strftime("%d %B  %Y")
          }, status: :ok and return
      end
    end
    render json: {}, status: :unprocessable_entity
  end

  def update
    if billing_info_valid?
      current_user.attributes = billing_params

      if current_user.stripe_id.nil?
        success = current_user.create_subscription
      elsif !current_user.subscription_active
        success = current_user.subscribe
      elsif current_user.stripe_token_changed? &&  current_user.plan_type_changed?
        success = current_user.change_plan
        success = current_user.change_card
      elsif current_user.stripe_token_changed?
        success = current_user.change_card
      elsif  current_user.plan_type_changed?
       success = current_user.change_plan
     else
      success = current_user.save
    end
    if success
      render json: current_user.as_json(
        only: [:cc_brand,
          :last_4_digits,
          :plan_type,
          :subscription_end,
          :subscription_active]),
      status: :ok and return
    end
  end

  render json: {error: current_user.errors.full_messages}, status: :unprocessable_entity
end

def destroy
  current_user.cancel_subscription
  redirect_to edit_user_settings_billing_path
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
