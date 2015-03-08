require 'rails_helper'

feature "User Registration", retry: 4, js: true do

  context "when visiting Sign Up page" do
    background do
      visit join_path
    end

    context "registering with valid data" do
      given(:email) { "test@gmail.com" }
      background do
        fill_form_with_valid_data(email: email)
      end

      scenario "new user is created" do
        click_button "Sign up"
        wait_for_ajax
        expect(page).to have_content 'start your free trial'
      end
    end
    context "registering with invalid data" do
      given(:email) { "testgmail.com" }

      background do
        fill_form_with_valid_data(email: email)
      end

      scenario "show error message" do
        click_button "Sign up"
        wait_for_ajax
        expect(page).to have_content('Sign In')
      end
    end
  end

  context "Social Sign Up" do
    background do
     mock_auth_hash
     visit join_path
   end
   scenario "User clicks on Facebook link" do
    VCR.use_cassette("feature_signup_with_facebook", :record => :new_episodes) do
      find(".fb-btn").click
      expect(page).to have_content 'start your free trial'
    end
  end

  scenario "User clicks on Google link" do
    VCR.use_cassette("feature_signup_with_google", :record => :new_episodes) do
      find(".google-btn").click
      expect(page).to have_content 'start your free trial'
    end
  end
end
end

def fill_form_with_valid_data(args={})
  email = args.fetch(:email, "email@example.com")

  fill_in "user_name", with: 'Rocco'
  fill_in "user_email", with: email
  fill_in "user_password", with: "my-super-secret-password"
end

def register
  click_link "Sign Up"
end