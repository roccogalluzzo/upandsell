require 'spec_helper.rb'

feature 'Customer update account settings' do

  background do
   login
   visit customer_settings_account_path
 end
 scenario 'update password' do
  fill_in 'customer[password]', :with => 'password'
  fill_in 'customer[password_confirmation]', :with => 'password'
  click_on 'Update Customer'
  expect(page).to have_content('Account Updated')
end

scenario 'update password without confirmation valid' do
  fill_in 'customer[password]', :with => 'password'
  fill_in 'customer[password_confirmation]', :with => 'wrongpassword'
  click_on 'Update Customer'
  expect(page).to_not have_content('Account Updated')
end

scenario 'update email' do
  fill_in 'customer[email]', :with => 'ciao@faf.com'
  click_on 'Update Customer'
  expect(page).to have_content('Account Updated')
end
end
