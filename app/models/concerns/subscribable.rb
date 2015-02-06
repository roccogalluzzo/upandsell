module Subscribable
  extend ActiveSupport::Concern

  def create_subscription
    customer = Subscription::Stripe.create_customer(self)
    return customer if customer == false

    self.last_4_digits = customer.cards.data.first["last4"]
    self.cc_brand = customer.cards.data.first["brand"].downcase
    self.stripe_id = customer.id
    self.subscription_end = Time.at(customer.subscriptions.data[0].current_period_end).to_datetime
    self.subscription_active = true
    self.save
  end

  def change_plan
    subscription = Subscription::Stripe.new(self.stripe_id).change_plan(self.plan_type)
    return subscription if subscription == false

    self.subscription_active = true
    self.subscription_end = Time.at(subscription.current_period_end).to_datetime
    self.save
  end

  def change_card
    customer = Subscription::Stripe.new(self.stripe_id).change_card(self.stripe_token)
    return customer if customer == false

    self.last_4_digits = customer.cards.data.first["last4"]
    self.cc_brand = customer.cards.data.first["brand"].downcase
    self.save
  end

  def cancel_subscription
    customer = Subscription::Stripe.new(self.stripe_id).cancel_subscription
    return customer if customer == false

    self.subscription_active = false
    self.save
  end

  def update_metadata

  end

  def trial_end
    return 0 unless self.stripe_id.nil?
    if self.beta_signup?
      return 6.months.from_now.to_i
    end
    Rails.application.secrets.trial_days.days.from_now.to_i
  end

end
