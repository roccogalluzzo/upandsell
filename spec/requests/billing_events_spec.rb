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
      expect{ post '/stripe', id: 'evt_customer_subscription_trial_will_end' }
      .to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end
  end

  describe "invoice.payment_succeeded" do
    before do
      create(:user, stripe_id: 'cus_5nDOObvDCZYY9t')
    end
    it "is successful" do
      stub_event 'evt_invoice_payment_succeeded'
      expect_any_instance_of(Subscription::Invoice)
      .to receive(:process_payment).and_return(build(:subscription_invoice))
      expect{post '/stripe', id: 'evt_invoice_payment_succeeded'}
      .to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end
    it "is 0" do
      stub_event 'evt_invoice_payment_zero'
      expect_any_instance_of(Subscription::Invoice)
      .to receive(:process_payment).and_return(build(:subscription_invoice))
      expect{ post '/stripe', id: 'evt_invoice_payment_zero'}
      .to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(0)
    end
  end

  describe "invoice.created" do
    before do
      create(:user, stripe_id: 'cus_5nDOObvDCZYY9t')
    end
    it "is successful" do
      stub_event 'evt_invoice_created'
      expect_any_instance_of(Subscription::Invoice).to receive(:ensure_vat)
      .and_return(build(:subscription_invoice))
      post '/stripe', id: 'evt_invoice_created'
    end
  end

  describe "invoice.payment_failed" do
    before do
      create(:user, stripe_id: 'cus_00000000000000')
    end
    it "is successful" do
      stub_event 'evt_invoice_payment_failed'
      expect{ post '/stripe', id: 'evt_invoice_payment_failed' }
      .to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end
  end

  describe "customer.subscription_deleted" do
    before do
      @user = create(:user, stripe_id: 'cus_00000000000000')
    end
    it "is successful" do
      stub_event 'evt_customer_subscription_deleted'
      expect{ post '/stripe', id: 'evt_customer_subscription_deleted' }
      .to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
      sub_end = @user.subscription_end
      @user.reload
      expect(@user.subscription_active).to eq false
      expect(@user.subscription_deleted).to eq true
      expect(@user.subscription_end).to eq sub_end
    end
  end

  describe "customer.subscription_updated" do
    before do
      @user = create(:user, stripe_id: 'cus_00000000000000')
    end
    it "is successful" do
      stub_event 'evt_customer_subscription_updated'
      post '/stripe', id: 'evt_customer_subscription_updated'

      sub_end = @user.subscription_end
      @user.reload
      expect(@user.subscription_active).to eq true
      expect(@user.subscription_deleted).to eq false
      expect(@user.subscription_end).to_not eq sub_end
    end
  end
  describe "charge.refunded" do
    before do
      create(:user, stripe_id: 'cus_00000000000000')
    end
    it "is successful" do
      stub_event 'evt_charge_refunded'
      expect_any_instance_of(Subscription::Invoice).to receive(:process_refund)
      .and_return(true)
        post '/stripe', id: 'evt_charge_refunded'
    end
  end
end
