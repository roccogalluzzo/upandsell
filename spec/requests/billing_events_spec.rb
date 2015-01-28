require 'rails_helper'

describe SubscriptionWebhooks do

  describe 'trial_will_end' do

    before do
      stub_event 'evt_customer_subscription_trial_will_end'
    end
    it 'should send the trial_will_end email to the user' do
      create(:stripe_user)
      Sidekiq::Worker.clear_all
      post '/stripe', id: 'evt_customer_subscription_trial_will_end'
      expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
    end
  end

  describe 'payment_succeeded'
  describe 'payment_failed'
  describe 'subscription.deleted'

  def stub_event(fixture_id, status = 200)
    stub_request(:get, "https://api.stripe.com/v1/events/#{fixture_id}").
    to_return(status: status,
      body: File.read("spec/fixtures/stripe_webhooks/#{fixture_id}.json") )
  end
end