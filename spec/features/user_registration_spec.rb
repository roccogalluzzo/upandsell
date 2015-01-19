require 'rails_helper'

feature "User Registration", js: true do

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
        if ENV['COVERAGE_REPORTS']
          save_screenshot('shippable/capybara/test.png', :full => true)
        end
        expect(page).to have_content 'Complete your sign up process'
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
        save_screenshot('file.png', :full => true)
        expect(page).to have_content('Sign In')
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