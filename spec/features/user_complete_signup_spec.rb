require 'rails_helper'

feature "User complete Sign Up", js: true do

  context "when submit Billing form" do
    background do
      SessionHelpers.create_logged_in_user
      visit user_complete_signup_path
    end

    context "with valid data" do

      before(:all) do
        @client = StripeMock.start_client
      end

      before(:each) do
        @client.clear_server_data
        Stripe::Plan.create(
          amount: 2499,
          interval: 'month',
          name: 'Monthly App Plan',
          currency: 'eur',
          id: 'MONTHLY_PLAN')
        Stripe::Plan.create(
          amount: 24999,
          interval: 'month',
          name: 'Yearly App Plan',
          currency: 'eur',
          id: 'YEARLY_PLAN')

        fill_common_form_fields
        fill_credit_card
        token = StripeMock.generate_card_token(last4: "1111", exp_year: 2020)
        stub_success_token(token)
      end

      after(:all) do
       @client.close!
     end

     scenario "of a private IT" do
      submit_subscription_data
      expect(page).to have_content 'SETUP'
    end

    scenario "of a company IT " do
     find('#type-company')
     .trigger('click')
     submit_subscription_data
     expect(page).to have_content 'SETUP'
   end

   scenario "of a private EU" do
     select1('user_country', query: 'France', :choose => "France")
     submit_subscription_data
     expect(page).to have_content 'SETUP'
   end

   scenario "of a company EU " do
    select1('user_country', query: 'France', :choose => "France")
    find('#type-company')
    .trigger('click')
    submit_subscription_data
    expect(page).to have_content 'SETUP'
  end

  scenario "private from the rest of the world" do
    select1('user_country', query: 'Canada', :choose => "Canada")
    submit_subscription_data
    expect(page).to have_content 'SETUP'
  end

end
end
end

def submit_subscription_data
  click_button('Start your 30 day FREE TRIAL')
  wait_for_ajax
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

def select1(id, options)
  page.execute_script %Q{
    i = $('#s2id_#{id} .select2-offscreen');
    i.trigger('keydown').val('#{options[:query]}').trigger('keyup');
  }

  within(".select2-drop-active") do
   find(".select2-result-label", :text => options[:choose]).click
 end
end
