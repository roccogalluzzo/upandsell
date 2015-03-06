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
   expect(page).to have_content 'Connected'
 end



 scenario "User connect Paypal Account" do
  visit edit_user_settings_payments_path
  VCR.use_cassette('paypal_connect', record: :once) do
    find(".paypal-connect").click
    expect(page).to have_content 'start your free trial'
  end
end
scenario "User don't connect Paypal Account" do
  visit edit_user_settings_payments_path
  find(".paypal-connect").click
  expect(page).to have_content 'start your free trial'
end
end


describe "Paypal Connect" do

  it "redirect to paypal connect url" do
    VCR.use_cassette('paypal_connect', record: :once) do
      expect(subject).not_to redirect_to(action: :edit)
    end
  end

  xit "save paypal connect to db" do
    VCR.use_cassette('paypal_connect_complete') do
      action = get paypal_integration_callback_path,
      request_token: 'AAAAAAAZ6-lEF6DxKBwh', verification_code: 'M.TMIZXa61gEo6Qtm33xFA'
      expect(flash[:notice]).to match 'Gateway Connected'
    end
  end

  it "no save paypal connect to db" do
    VCR.use_cassette('paypal_connect_incomplete') do
      action = get paypal_integration_callback_path,
      request_token: 'AAAAZ6-lEF6DxKBwh', verification_code: 'M.TMIZXa61gEo6Qtm33xFA'

      expect( flash[:alert]).to match 'Error during'
    end
  end

end
