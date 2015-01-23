include Warden::Test::Helpers
Warden.test_mode!

module SessionHelpers
  def self.create_logged_in_user
    user = FactoryGirl.create(:user)
    login(user)
    user
  end

  def self.create_logged_in_active_user(token)
    user = FactoryGirl.create(:active_user)
    customer = Stripe::Customer.create({
      email: user.email,
      card: token,
      plan: 'MONTHLY_PLAN'
      })

    user.stripe_id = customer.id
    user.stripe_token = token
    user.save
    login(user)
    user
  end

  def self.login(user)
    login_as user, scope: :user
  end
end

