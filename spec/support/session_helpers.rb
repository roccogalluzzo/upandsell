module Features
  module SessionHelpers
    def sign_up(email, password)
      visit new_customer_registration_path
      fill_in 'Email', with: email
      fill_in 'customer[password]', with: password, exact: true
      fill_in 'customer[password_confirmation]', with: password, exact: true
      click_button 'Sign up'
    end
    def sign_in(email, password)
      visit new_customer_session_path
      puts page.body
      fill_in 'customer_email', with: email
      fill_in 'customer[password]', with: password, exact: true
click_button 'Sign in'
    end
  end
end
