module SubscriptionWebhooks
  class InvoiceCreated
    def call(event)
     stripe_invoice = Stripe::Invoice.construct_from(event.data)['object']
     invoice = Subscription::Invoice.new(customer_id: stripe_invoice.customer)
     invoice.ensure_vat(stripe_invoice_id: stripe_invoice.id)
   end
 end
end
