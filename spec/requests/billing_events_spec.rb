require 'rails_helper'

describe SubscriptionWebhooks, sidekiq: true do
  def stub_event(fixture_id, status = 200)
    stub_request(:get, "https://api.stripe.com/v1/events/#{fixture_id}").
    to_return(status: status, body:
      Rails.root.join('spec', 'fixtures', 'stripe_webhooks', "#{fixture_id}.json"))
  end

  describe "customer.subscription_trial_will_end" do
    it "is successful" do
     stub_event 'evt_customer_subscription_trial_will_end'
     create(:user, stripe_id: 'cus_test2')
     expect{
      post '/stripe', id: 'evt_customer_subscription_trial_will_end'
      }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end
  end

  describe "invoice.payment_succeeded" do
    before do
     create(:user, stripe_id: 'cus_5nDOObvDCZYY9t')
   end
   it "is successful" do
     stub_event 'evt_invoice_payment_succeeded'
     VCR.use_cassette('webhook_payment_success', :record => :new_episodes) do
       expect_any_instance_of(Subscription::Invoice).to receive(:process_payment)
       .and_return(build(:subscription_invoice))
       expect{
        post '/stripe', id: 'evt_invoice_payment_succeeded'
        }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
      end
    end
    it "is 0" do
     stub_event 'evt_invoice_payment_zero'
     VCR.use_cassette('webhook_payment_success_zero', :record => :new_episodes) do
       expect_any_instance_of(User).to receive(:renew_subscription)
       expect{
        post '/stripe', id: 'evt_invoice_payment_zero'
        }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(0)
      end
    end
  end
end
