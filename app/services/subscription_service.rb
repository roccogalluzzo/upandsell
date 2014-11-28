class SubscriptionService

  def self.subscribe(user, card_token, yearly = false)
    Stripe.api_key = Rails.application.secrets.stripe['api_key']

    if user.stripe_id.nil?

    customer = Stripe::Customer.create(
    card: card_token,
    email: user.email,
    metadata: {id: user.id, country: user.country, name: user.legal_name,
      type: user.business_type, tax_code: user.tax_code },
      plan: yearly ? 'YEARLY_PLAN' : 'MONTHLY_PLAN'
      )
    else
      customer = Stripe::Customer.retrieve(user.stripe_id)
      customer.subscriptions.create(plan: yearly ? 'YEARLY_PLAN' : 'MONTHLY_PLAN', card: card_token)
    end

      user.last_4_digits = customer.cards.data.first["last4"]
      user.stripe_id = customer.id
      user.save
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: " + e.message
      false
  end

  def self.cancel_subscription(user)
    unless user.stripe_id.nil?
      customer = Stripe::Customer.retrieve(user.stripe_id)
      unless customer.nil? or customer.respond_to?('deleted')
        subscription = customer.subscriptions.data[0]
        customer.subscriptions.retrieve(subscription.id).delete(at_period_end: true).cancel_at_period_end
      end
    end
  rescue Stripe::StripeError => e
    Rails.logger.error "Stripe Error: " + e.message
    false
  end
end
