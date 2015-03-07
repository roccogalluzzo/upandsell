require 'rails_helper'

describe Subscription::Stripe, stripe: true do

  before do
    @user = create(:active_user)
  end

  describe '@create_customer'
  describe '#apply_coupon'

  describe '#subscribe'

  describe '#change_plan'

  describe '#change_card'

  describe '#cancel_subscription'

  describe '#is_subscribed?'

end
