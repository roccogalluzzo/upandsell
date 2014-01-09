require 'spec_helper'

feature 'Customer signs up' do
  scenario 'with valid user data' do
    sign_up 'aoci@google.com', 'ciaociao'
    expect(page).to have_content('Logout')
  end
  scenario 'with invalid email' do
    sign_up 'invalid mail', 'ciao'
    expect(page).to have_content('invalid')
  end
  scenario 'with blank password' do
    sign_up 'ciocio@google.com', ''
    expect(page).to have_content('blank')
  end
end
