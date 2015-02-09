module SubscriptionWebhooks
  class ChargeRefunded
    def call(event)
      charge = Stripe::Charge.construct_from(event.data)['object']
      # we only handle full refunds for now
      byebug
      if charge.refunded
        invoice = Subscription::Invoice.new(customer_id: charge.customer)
        invoice.process_refund(stripe_invoice_id: charge.invoice)
      end
      # send emails
    end
  end
end
