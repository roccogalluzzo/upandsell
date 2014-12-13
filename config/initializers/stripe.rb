Stripe.api_key = Rails.application.secrets.stripe['api_key']

StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.trial_will_end', Service::Stripe::TrialWillEnd.new
  events.subscribe 'charge.succeeded', Service::Stripe::ChargeSucceeded.new
  events.subscribe 'charge.failed', Service::Stripe::ChargeFailed.new
  events.subscribe 'customer.subscription.deleted', Service::Stripe::CustomerSubscriptionDeleted.new
end
