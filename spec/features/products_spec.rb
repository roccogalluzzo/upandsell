require 'spec_helper'

feature 'User see product list' do
  scenario 'with valid email and password' do
    sign_up_with 'valid@example.com', 'password'

    expect(page).to have_content('Sign out')
  end


end