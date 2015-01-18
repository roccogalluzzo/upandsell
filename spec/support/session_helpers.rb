include Warden::Test::Helpers
Warden.test_mode!

module SessionHelpers
  def self.create_logged_in_user
    user = FactoryGirl.create(:user)
    login(user)
    user
  end

  def self.login(user)
    login_as user, scope: :user
  end
end

