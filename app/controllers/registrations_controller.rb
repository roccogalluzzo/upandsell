class RegistrationsController < Devise::RegistrationsController
  skip_after_filter :intercom_rails_auto_include

  def new
    @page_title = "Join us"
    if params[:ref]
     @ref = params[:ref]
   else
    @ref = cookies[:aff_tag]
  end

  @price_usd = 24.99.in(:eur).to(:usd).to_s(:plain).split('.')
  @price = @price_usd[0]
  @cents =  @price_usd[1]

  super
end

protected
def after_inactive_sign_up_path_for(resource)
  user_setup_path
end

def after_sign_up_path_for(resource)
  user_setup_path
end
end
