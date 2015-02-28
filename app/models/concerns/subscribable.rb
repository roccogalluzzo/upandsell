module Subscribable
  extend ActiveSupport::Concern

  def create_subscription
    customer = Subscription::Stripe.create_customer(self)
    return false if !customer

    self.last_4_digits = customer.cards.data.first["last4"]
    self.cc_brand = customer.cards.data.first["brand"].downcase
    self.stripe_id = customer.id
    self.subscription_end = Time.at(customer.subscriptions.data[0].current_period_end).to_datetime
    self.subscription_active = true
    self.subscription_deleted = false
    self.save
    customer
  end

  def subscribe
    stripe = Subscription::Stripe.new(customer_id: self.stripe_id)
    sub = stripe.subscribe(self.plan_type, self.stripe_token)
    return sub if sub == false

    self.last_4_digits = stripe.customer.cards.data.first["last4"]
    self.cc_brand =  stripe.customer.cards.data.first["brand"].downcase
    self.subscription_active = true
    self.subscription_deleted = false
    self.subscription_end = Time.at(sub.current_period_end).to_datetime
    self.save
  end

  def change_plan
    subscription = Subscription::Stripe.new(customer_id: self.stripe_id).change_plan(self.plan_type)
    return subscription if subscription == false

    self.subscription_active = true
    self.subscription_deleted = false
    self.subscription_end = Time.at(subscription.current_period_end).to_datetime
    self.save
  end

  def apply_coupon(code)
    return false if self.coupon_active == code
    return false if User.where(coupon_active: code).count >= 10

    subscription = Subscription::Stripe.new(customer_id: self.stripe_id)
    .apply_coupon(self.subscription_end + 3.months)
    return subscription if subscription == false

    self.coupon_active = code.upcase
    self.subscription_end = Time.at(subscription.current_period_end).to_datetime
    self.save
  end

  def change_card
    customer = Subscription::Stripe.new(customer_id: self.stripe_id).change_card(self.stripe_token)
    return customer if customer == false

    self.last_4_digits = customer.cards.data.first["last4"]
    self.cc_brand = customer.cards.data.first["brand"].downcase
    self.save
  end

  def cancel_subscription
    customer = Subscription::Stripe.new(customer_id: self.stripe_id).cancel_subscription
    return customer if customer == false
    self.subscription_deleted = true
    self.subscription_active = false
    self.save
  end

  def update_metadata

  end

  def trial_end
    return nil if Rails.env.development?
    return 0 unless self.stripe_id.nil?
    if self.beta_signup?
      return 6.months.from_now.to_i
    end
    Rails.application.secrets.trial_days.days.from_now.to_i
  end

end
