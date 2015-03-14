require 'rails_helper'

feature "User Create a Subscription",retry: 4, js: true, stripe: true do

  context "when submit Billing form" do
    background do
      @user = SessionHelpers.create_logged_in_user
      visit edit_user_settings_billing_path
    end

    context "with valid data" do
      scenario "should see subscription active page" do
        VCR.use_cassette("feature_billing_create_subscription") do
          fill_credit_card
          fill_common_form_fields
          token =  Stripe::Token.create(
            :card => {
              :number => "4242424242424242",
              :exp_month => 2,
              :exp_year => 2016,
              :cvc => "314"
              },
              ).id
          stub_success_token(token)
          find('.year-plan').trigger('click')
          click_button('Save')
          wait_for_ajax
          sleep 3
          expect(page).to have_content 'Next payment will be processed on'
        end
      end

    end
  end
end

def stub_success_token(token)
  proxy.stub('https://api.stripe.com:443/v1/tokens').
  and_return(Proc.new { |params|
    { :code => 200, :text => "#{params['callback'][0]}({
      'id': '#{token}',
      'livemode': false,
      'created': 1379062337,
      'used': false,
      'object': 'token',
      'type': 'card'
      },
      200)" } })
end

def fill_common_form_fields
  fill_in "user_legal_name", with: Faker::Name.name
  fill_in "user_tax_code", with: '12345678'
  fill_in "user_address", with: Faker::Address.street_address
  fill_in "user_zip_code", with: '89040'
  fill_in "user_city", with: Faker::Address.city
  fill_in "user_province", with: Faker::Address.state_abbr
end

def fill_credit_card
  fill_in "cc_number", with: '4111111111111111'
  fill_in "cc_expire", with: '10/20'
  fill_in "cc_cvc", with: '123'
end
