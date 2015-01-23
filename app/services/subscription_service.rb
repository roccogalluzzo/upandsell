class SubscriptionService

  def initialize(user)
    Stripe.api_key = Rails.application.secrets.stripe['api_key']
    @user = user
    @customer = self.get_customer
    @plans = {'monthly' => 'MONTHLY_PLAN', 'yearly' => 'YEARLY_PLAN'}
  end

  def subscribe
    if @customer.nil?
      trial_end = Rails.application.secrets.trial_days.days.from_now.to_i
      if @user.beta_signup?
        trial_end = 6.months.from_now.to_i
      end
      @customer = Stripe::Customer.create(
      card: @user.stripe_token,
      email: @user.email,
      metadata: {id: @user.id, country: @user.country, name: @user.legal_name,
        type: @user.business_type, tax_code: @user.tax_code },
        plan: @plans[@user.plan_type],
        trial_end: trial_end
        )
    elsif self.is_subscribed?
      self.update_subscription
      self.update_card
    elsif !self.is_subscribed?
      @customer.subscriptions.create(plan: @plans[@user.plan_type], card: @user.stripe_token)
    end

    @user.last_4_digits = @customer.cards.data.first["last4"]
    @user.cc_brand = @customer.cards.data.first["brand"].downcase
    @user.stripe_id = @customer.id
    @user.subscription_end = Time.at(@customer.subscriptions.data[0].current_period_end).to_datetime
    @user.subscription_active = true
    @user.save

    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: " + e.message
      false
  end

  def update_subscription
    unless @customer.nil? && !self.is_subscribed?
     subscription = @customer.subscriptions.retrieve(@customer.subscriptions.data[0].id)
     subscription.plan = @plans[@user.plan_type]
     subscription.prorate = false
     subscription.save
     @user.subscription_active = true
     @user.subscription_end = Time.at(subscription.current_period_end).to_datetime
     @user.save
    end

  rescue Stripe::StripeError => e
    Rails.logger.error "Stripe Error: " + e.message
    false
  end

  def update_card
    unless @customer.nil?
      @customer.card = @user.stripe_token
      @customer.save
      @user.last_4_digits = @customer.cards.data.first["last4"]
      @user.cc_brand = @customer.cards.data.first["brand"].downcase
      @user.save
    end

    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: " + e.message
      false
  end

  def cancel_subscription
      unless @customer.nil?
        subscription = @customer.subscriptions.data[0]
        @customer.subscriptions.retrieve(subscription.id).delete(at_period_end: true).cancel_at_period_end
        @user.subscription_active = false
        @user.save
      end

  rescue Stripe::StripeError => e
    Rails.logger.error "Stripe Error: " + e.message
    false
  end

  def get_customer
    unless @user.stripe_id.nil?
      customer = Stripe::Customer.retrieve(@user.stripe_id)
      return nil if customer.respond_to?('deleted')
      customer
    end
  end

  def is_subscribed?
      unless @customer.nil?
        subscription = @customer.subscriptions.data[0]
        if subscription && (subscription.status == 'trialing' || subscription.status == 'active')
          return true
        end
      end
      false
  end
end
