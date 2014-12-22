Stripe.api_key = Rails.application.secrets.stripe['api_key']

StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.trial_will_end', SubscriptionWebhooks::TrialWillEnd.new
  events.subscribe 'charge.succeeded', SubscriptionWebhooks::ChargeSucceeded.new
  events.subscribe 'charge.failed', SubscriptionWebhooks::ChargeFailed.new
  events.subscribe 'customer.subscription.deleted', SubscriptionWebhooks::CustomerSubscriptionDeleted.new
end
