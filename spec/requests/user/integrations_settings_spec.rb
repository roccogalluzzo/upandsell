require 'rails_helper'

describe "Integrations Settings" do
 before :all do
   post 'users/sign_in',
   'user[email]' => USER.email, 'user[password]' => USER.password
 end

 describe "Mailchimp Connect" do
  it "should store api token" do
    expect(get integration_callback_url('mailchimp'))
    .to redirect_to( edit_user_settings_integrations_path)
  end
end

describe "CreateSend Connect" do
  it "should store api token" do
    expect(get integration_callback_url('createsend'))
    .to redirect_to( edit_user_settings_integrations_path)
  end
end

end