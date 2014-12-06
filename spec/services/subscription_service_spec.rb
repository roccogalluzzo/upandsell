require 'rails_helper'

describe SubscriptionService do

  let(:valid_cc) {{number: '4242424242424242', exp_month: '10', exp_year: '15', cvc: '123'}}
  let(:invalid_cc) {{number: '4000000000000069', exp_month: '10', exp_year: '15', cvc: '123'}}

  describe '#subscribe' do
    it "should create new subscription" do
      VCR.use_cassette('valid_stripe_subscription', record: :new_episodes) do
        expect(SubscriptionService.new(USER).subscribe(valid_cc)).to eq(true)
      end
    end
  end

    describe '#cancel_subscription' do
      it "should unsubscribe an user" do
        VCR.use_cassette('stripe_unsubscription', record: :new_episodes) do
          SubscriptionService.new(USER).subscribe(valid_cc)
          expect(SubscriptionService.new(USER).cancel_subscription).to eq(true)
        end
      end

      it "should not unsubscribe an user if is not subscribed" do
        VCR.use_cassette('stripe_unsubscription_fails', record: :new_episodes) do
          expect(SubscriptionService.new(USER).cancel_subscription).to eq(false)
        end
      end
      end
end
