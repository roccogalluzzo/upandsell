require 'rails_helper'

feature "User complete Sign Up", js: true do

  context "when submit Billing form" do
    background do
      SessionHelpers.create_logged_in_user
      visit user_complete_signup_path
    end

    context "with valid data" do
      background do
        fill_common_form_fields
        fill_credit_card
      end

      scenario "of a private IT" do

      end

      scenario "of a company IT " do
         find('#type-company')
        .trigger('click')
      end

      scenario "of a private EU" do
       select1('user_country', query: 'France', :choose => "France")
     end

     scenario "of a company EU " do
      select1('user_country', query: 'France', :choose => "France")
      find('#type-company')
      .trigger('click')
    end

    scenario "private from the rest of the world" do
      select1('user_country', query: 'Canada', :choose => "Canada")
    end

  end
end
end

def fill_common_form_fields
  fill_in "user_legal_name", with: Faker::Name.name
  fill_in "user_tax_code", with: '12345678'
  fill_in "user_address", with: Faker::Address.street_address
  fill_in "user_zip_code", with: Faker::Address.zip_code
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
