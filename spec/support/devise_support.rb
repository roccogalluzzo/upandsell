
module ValidUserRequestHelper
  include Warden::Test::Helpers
  def self.sign_in_as_a_valid_user
   @user ||= FactoryGirl.create :user
   post_via_redirect 'user/session',
   'user[email]' => @user.email, 'user[password]' => @user.password
 end
end

