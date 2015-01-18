require 'rails_helper'

feature "User Login", js: true do

  context "when visiting Sign In page" do
    background do
      visit login_path
    end

    context "with valid data" do
      given(:user) { FactoryGirl.create(:user)}

      scenario "user is redirected to dashboard" do
        user.confirmed_at = Time.now
        user.save
        fill_in "user_email", with: user.email
        fill_in "user_password", with: '12345678'
        click_button "Sign in"
        wait_for_ajax
        expect(page).to have_content 'SUMMARY'
      end
    end

    context "and insert invalid data" do
      given(:email) { "test@gmail.com" }

      background do
        fill_sform_with_valid_data(email: email)
      end

      scenario "show error message" do
        click_button "Sign in"
        wait_for_ajax
        expect(page).to have_content('Invalid email or password')
      end
    end
  end

end

def fill_sform_with_valid_data(args={})
  email = args.fetch(:email, "email@example.com")

  fill_in "user_email", with: email
  fill_in "user_password", with: '12345678'
end
