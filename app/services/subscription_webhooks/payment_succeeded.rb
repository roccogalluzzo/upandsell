module SubscriptionWebhooks
  class PaymentSucceeded
    def call(event)
      stripe_invoice = Stripe::Invoice.construct_from(event.data)['object']
      invoice = Subscription::Invoice.new(customer_id: stripe_invoice.customer)
      sub_invoice = invoice.process_payment(stripe_invoice_id: stripe_invoice.id)

      user = User.find_by_stripe_id stripe_invoice.customer
      user.renew_subscription

      unless stripe_invoice.total == 0
        UserMailer.delay.payment_succeeded_email(user.id, sub_invoice.id) if user
      end
    end
  end
end
