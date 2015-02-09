module SubscriptionWebhooks
  class PaymentSucceeded
    def call(event)
     stripe_invoice = Stripe::Invoice.construct_from(event.data)['object']
     invoice = Subscription::Invoice.new(customer_id: stripe_invoice.customer)
     invoice.process_payment(stripe_invoice_id: stripe_invoice.id)

      # send emails
    end
  end
end
