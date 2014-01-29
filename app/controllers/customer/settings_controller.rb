class Customer::SettingsController < Customer::BaseController

  def account
    #change email, password, default currency
    @customer = current_customer
  end

  def payments
   #set payment options
   @customer = current_customer
   if params[:code]
     #redirect from paymill site
     response = Billing::Paymill::Unite.access_token(params[:code])
     @customer.add_credit_card(response)
     @customer = current_customer
   end
   @paymill_url = Billing::Paymill::Unite.auth_url
 end

 def update_account
  @customer = Customer.find(current_customer.id)
  unless @customer.blank?
    params[:customer].delete(:password) if params[:customer][:password].blank?
    params[:customer].delete(:password_confirmation) if params[:customer][:password_confirmation].blank?

    if @customer.update_account(customer_params)
      # Sign in the user bypassing validation in case his password changed
      sign_in @customer, :bypass => true
      redirect_to customer_settings_account_path, notice: 'Account Updated'
    else
      render 'account'
    end
  end
end

private

def customer_params
  params.require(:customer).permit( :email, :password,
    :password_confirmation)
end
 # TODO activate/deactivate newsletter weekly report
end
