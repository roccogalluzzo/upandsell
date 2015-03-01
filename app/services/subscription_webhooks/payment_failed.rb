module SubscriptionWebhooks
  class PaymentFailed
    def call(event)
     stripe_invoice = Stripe::Invoice.construct_from(event.data)['object']
     user = User.find_by_stripe_id stripe_invoice.customer
      # send emails
      UserMailer.delay.payment_failed_email(user.id) if user
    end
  end
end
