require 'spec_helper'

feature 'Customer signs out' do
  background do
    customer = Customer.new(:email => 'test@example.com', :password => 'password',
      :password_confirmation => 'password')
    customer.save
    sign_in('test@example.com', 'password')
  end
  scenario 'and return to main page' do
    sign_out
    expect(page).to have_content('Sign in')
  end
end
