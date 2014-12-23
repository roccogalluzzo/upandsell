require 'rails_helper'

describe "Integrations Settings" do
 before :all do
   post 'users/sign_in',
   'user[email]' => USER.email, 'user[password]' => USER.password
 end

 describe "Mailchimp" do
  it "store api token on db" do
  end
end

describe "CreateSend Connect" do
  it "should store api token" do
  end
end

end
