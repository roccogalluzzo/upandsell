require 'rails_helper'

describe "Integrations Settings" do
  before :each do
  user = create(:user)
  post 'users/sign_in',
  'user[email]' => user.email, 'user[password]' => user.password
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
