require 'spec_helper'

feature 'Customer Sign in' do
  background do
    customer = Customer.new(:email => 'test@example.com', :password => 'password',
      :password_confirmation => 'password')
    customer.save
  end
  scenario 'with valid data' do
    sign_in('test@example.com', 'password')
    expect(page).to have_content('Logout')
  end
  scenario 'with invalid data' do
    sign_in('test@example.com', 'wrongpassword')
    expect(page).to have_content('Sign in')
  end
  scenario 'with non confirmed sign up'
end
