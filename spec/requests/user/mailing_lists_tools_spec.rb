require 'rails_helper'

describe "Mailing List" do
  before :each do
   user = create(:user)
   post 'users/sign_in',
   'user[email]' => user.email, 'user[password]' => user.password
 end

 describe "Create" do
  it "should create new ML" do
    pending
    expect(post user_tools_mailing_lists_path(name: 'new mail'))
    .to redirect_to( edit_user_settings_integrations_path)
  end
end



end