require 'rails_helper'

describe SubscriptionService do

  let(:valid_cc) {{number: '4242424242424242', exp_month: '10', exp_year: '15', cvc: '123'}}
  let(:invalid_cc) {{number: '4000000000000002', exp_month: '10', exp_year: '15', cvc: '123'}}
  describe '#subscribe' do
    it "should create new subscription" do
      VCR.use_cassette('valid_stripe_subscription', record: :new_episodes) do
        expect( SubscriptionService.subscribe(USER, valid_cc)).to eq(true)
      end
    end
    it "should fail to create new subscription" do
      VCR.use_cassette('invalid_stripe_subscription', record: :new_episodes) do
        expect( SubscriptionService.subscribe(USER, invalid_cc)).to eq(false)
      end
    end
  end
    describe '#cancel_subscription' do
      it "should unsubscribe an user" do
        VCR.use_cassette('stripe_unsubscription', record: :new_episodes) do
          SubscriptionService.subscribe(USER, valid_cc)
          expect( SubscriptionService.cancel_subscription(USER)).to eq(true)
        end
      end
      end
end
