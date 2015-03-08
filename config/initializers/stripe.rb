Stripe.api_key = Rails.application.secrets.stripe['api_key']

StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.trial_will_end', SubscriptionWebhooks::TrialWillEnd.new
  events.subscribe 'invoice.payment_succeeded', SubscriptionWebhooks::PaymentSucceeded.new
  events.subscribe 'invoice.payment_failed', SubscriptionWebhooks::PaymentFailed.new
  events.subscribe 'customer.subscription.deleted', SubscriptionWebhooks::CustomerSubscriptionDeleted.new
  events.subscribe 'customer.subscription.updated', SubscriptionWebhooks::CustomerSubscriptionUpdated.new
  events.subscribe 'invoice.created', SubscriptionWebhooks::InvoiceCreated.new
  events.subscribe 'charge.refunded', SubscriptionWebhooks::ChargeRefunded.new
end
