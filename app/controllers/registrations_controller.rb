class RegistrationsController < Devise::RegistrationsController
  skip_after_filter :intercom_rails_auto_include

  def new
    @page_title = "Join us"
    @price_usd = 24.99.in(:eur).to(:usd).to_s(:plain).split('.')
    @price = @price_usd[0]
    @cents =  @price_usd[1]

    super
  end

end
