require 'rails_helper'

feature "User complete Sign Up", js: true do

  context "when submit Billing form" do
    background do
      @user = SessionHelpers.create_logged_in_user
      VCR.use_cassette("load_stripe_js", :record => :new_episodes) do
        visit user_complete_signup_path
      end
    end

    context "with valid data" do

      before(:each) do
        fill_common_form_fields
        fill_credit_card
      end

      scenario "of a private IT" do
        VCR.use_cassette("feature_complete_sign_up_private_IT", :record => :new_episodes) do
          submit_subscription_data
          expect(page).to have_content 'SETUP'
        end
      end

      scenario "of a company IT " do
        VCR.use_cassette("feature_complete_sign_up_company_IT", :record => :new_episodes) do
         find('#type-company')
         .trigger('click')
         submit_subscription_data
         expect(page).to have_content 'SETUP'
       end
     end

     scenario "of a private EU" do
      VCR.use_cassette("feature_complete_sign_up_private_EU", :record => :new_episodes) do
       select1('user_country', query: 'France', :choose => "France")
       submit_subscription_data
       expect(page).to have_content 'SETUP'
     end
   end

   scenario "of a company EU " do
    VCR.use_cassette("feature_complete_sign_up_company_EU", :record => :new_episodes) do
      select1('user_country', query: 'France', :choose => "France")
      find('#type-company')
      .trigger('click')
      submit_subscription_data
      expect(page).to have_content 'SETUP'
    end
  end

  scenario "private from the rest of the world" do
    VCR.use_cassette("feature_complete_sign_up_extra_EU", :record => :new_episodes) do
      select1('user_country', query: 'Canada', :choose => "Canada")
      submit_subscription_data
      expect(page).to have_content 'SETUP'
    end
  end

  scenario "Yearly Plan" do
    VCR.use_cassette("feature_complete_sign_up_extra_EU_yearly", :record => :new_episodes) do
    select1('user_country', query: 'Canada', :choose => "Canada")
    find('.year-plan').trigger('click')

    submit_subscription_data
    sleep 2
    visit edit_user_settings_billing_path
    expect(page).to have_content 'YEARLY PLAN'
  end
end

end
end
end

def submit_subscription_data
  click_button('Start your 14 day FREE TRIAL')
  wait_for_ajax
end

def stub_success_token(token)
  proxy.stub('https://api.stripe.com/v1/tokens').
  and_return(Proc.new { |params|
    { :code => 200, :text => "#{params['callback'][0]}({
      'id': 'ciao',
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
