require 'rails_helper'

describe "Mailing List" do
 before :all do
   post 'users/sign_in',
   'user[email]' => USER.email, 'user[password]' => USER.password
 end

 describe "Create" do
  it "should create new ML" do
    expect(post user_tools_mailing_lists_path(name: 'new mail'))
    .to redirect_to( edit_user_settings_integrations_path)
  end
end



end