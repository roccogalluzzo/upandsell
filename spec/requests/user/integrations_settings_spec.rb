require 'rails_helper'

describe "Integrations Settings" do
 before :all do
   post 'users/sign_in',
   'user[email]' => USER.email, 'user[password]' => USER.password
 end

 describe "Mailchimp" do
  it "store api token on db" do
    get integration_callback_url('mailchimp')
    user = User.find USER.id
    expect(user.mailchimp_token).to eq('mock_token-us1')
  end
end

describe "CreateSend Connect" do
  it "should store api token" do
    get integration_callback_url('createsend')
    user = User.find USER.id
    expect(user.createsend_token).to eq('mock_token')
  end
end

end