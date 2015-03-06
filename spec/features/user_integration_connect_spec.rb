require 'rails_helper'

feature "Connect with Third party services" do
  background do
    VCR.use_cassette("feature_billing_create_customer", :record => :new_episodes) do
      token = Stripe::Token.create(
        :card => {
          :number => "4242424242424242",
          :exp_month => 2,
          :exp_year => 2016,
          :cvc => "314"
          },
          ).id
      @user = SessionHelpers.create_logged_in_active_user(token)
    end
  end

  scenario "User connect MailChimp Account" do
    mock_auth_hash
    visit edit_user_settings_integrations_path
    find(".mailchimp-connect").click
    expect(page).to have_content 'Connected'
    @user.reload
    expect(@user.mailchimp_token).to eq 'mock_token-us1'
  end

  scenario "User connect Createsend Account" do
   mock_auth_hash
   visit edit_user_settings_integrations_path
   find(".createsend-connect").click
   expect(page).to have_content 'Connected'
   @user.reload
   expect(@user.createsend_token).to have_content 'mock_token'
 end



 scenario "User connect Paypal Account" do
   VCR.use_cassette('paypal_connect_complete', record: :once) do
    visit paypal_integration_callback_path(request_token: 'AAAAAAAcrl.7mjcjpKjl', verification_code: 'H2Iew8OWbpaUS4AIql70Pw')
    expect(page).to have_content 'Gateway Connected'
    @user.reload
    expect(@user.paypal).to eq true
    expect(@user.paypal_email.nil?).to eq false
    expect(@user.paypal_token.nil?).to eq false
    expect(@user.paypal_token_secret.nil?).to eq false
  end
end

end
