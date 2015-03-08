require 'rails_helper'

describe Subscription::Stripe, stripe: true do

  before do
    @user = create(:active_user)
  end

  describe '@create_customer'

  describe '#apply_coupon' do
    it 'apply a coupon' do
      VCR.use_cassette("service_stripe_apply_coupon") do
        @user.stripe_token  = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 2,
            :exp_year => 2016,
            :cvc => "314"
            },
            ).id
        @user.save
        customer = @user.create_subscription
        stripe = Subscription::Stripe.new(customer_id: customer.id)
        expect(stripe.apply_coupon(Time.at(1436374254).to_datetime).trial_end).to eq 1436374254
      end
    end
    it 'doesnt apply a coupon' do
      VCR.use_cassette("service_stripe_apply_coupon_error") do
        stripe = Subscription::Stripe.new(customer_id: 'cus_fake')
        expect(stripe.apply_coupon(Time.at(1436374254).to_datetime)).to eq false
      end
    end
  end

  describe '#subscribe'

  describe '#change_plan'

  describe '#change_card'

  describe '#cancel_subscription'

  describe '#is_subscribed?'

end
