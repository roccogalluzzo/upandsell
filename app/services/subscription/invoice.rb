module Subscription
  class Invoice
   OrphanRefund = Class.new(StandardError)
   AlreadyFinalized = Class.new(StandardError)

  # customer_id - Stripe customer id.
  def initialize(customer_id:)
    @customer_id = customer_id
    @user = User.find_by_stripe_id(customer_id)
  end

  def ensure_vat(stripe_invoice_id:)
    # Get/create an internal invoice.
    invoice = ensure_invoice(stripe_invoice_id)
    # Only apply VAT if not applied yet.
    if !invoice.added_vat?
      stripe_invoice = stripe_service.apply_vat(invoice_id: stripe_invoice_id)
      invoice.added_vat!
      snapshot_customer(invoice)
    end

    invoice
  rescue ::Stripe::InvalidRequestError
    # This means we could not add VAT because the invoice is not editable anymore.
    # The invoice was probably created through #create_subscription so VAT and snapshotting
    # will be handled there. Nothing to do anymore here.
    invoice
  end

  def process_payment(stripe_invoice_id:)
    # Get/create an internal invoice and a Stripe invoice.
    invoice = ensure_invoice(stripe_invoice_id)
    stripe_invoice = ::Stripe::Invoice.retrieve(stripe_invoice_id)

    # Finalize the invoice.
    # Unless if the invoice's total amount is 0, then we don't
    # need to make an invoice for it.
    invoice.finalize! unless stripe_invoice.total.zero?

    # Now we are sure nothing is going to change the invoice anymore.
    # Do a final calculation of the invoice amounts.
    invoice.update(stripe_service.calculate_final(stripe_invoice: stripe_invoice))
    snapshot_invoice(invoice, stripe_invoice)

    # Take a snapshot of the card used to make payment.
    # Note: There will be no charge in two cases:
    #   1. The invoice total is 0 so no charge is needed.
    #   2. The invoice could be paid with credit.
    #
    if stripe_invoice.charge
      charge = ::Stripe::Charge.retrieve(stripe_invoice.charge)
      snapshot_card(charge.card, invoice)
    end

    invoice
  rescue Invoice::AlreadyFinalized
  end

  def process_refund(stripe_invoice_id:)
    invoice = SubscriptionInvoice.find_by_stripe_id stripe_invoice_id

    if invoice
      credit_note = SubscriptionInvoice.create \
      credit_note: true,
      user_id:  @user.id,
      stripe_id: invoice.stripe_id,
      reference_number: invoice.id,
      stripe_customer_id: @customer_id

      credit_note.finalize!
    else
      raise OrphanRefund
    end
    invoice = SubscriptionInvoice.find_by_stripe_id stripe_invoice_id
  end

  # Loads VIES data into the invoice model.
  #
  # Raises VatService::ViesDown if the VIES service is down.
  def load_vies_data(invoice: invoice)
    details = vat_service.details(vat_number: invoice.customer_vat_number,
      own_vat: AppSettings.seller_vat_number)

    invoice.update \
    vies_company_name: details[:name].strip,
    vies_address: details[:address].strip,
    vies_request_identifier: details[:request_identifier]
  end
  private

  def snapshot_invoice(invoice, stripe_invoice)
    if  !stripe_invoice.lines.data.first.plan.nil?
      plan = stripe_invoice.lines.data.first.plan.id
    else
      plan = nil
    end
    invoice.update(
      stripe_plan_id: plan,
      invoice_period_start:  stripe_invoice.period_start,
      invoice_period_end: stripe_invoice.period_end,
      invoice_lines: stripe_invoice.lines
      )
  end

  def snapshot_customer(invoice)
    customer = stripe_service.customer_metadata

    # Save to invoice
    invoice.update(
      customer_name: customer.legal_name,
      customer_country_code: customer.country,
      customer_address: customer.address,
      customer_city: customer.city,
      customer_cap: customer.zip_code,
      customer_vat_registered: customer.company?,
      customer_vat_number: customer.tax_code,
      stripe_customer_id: @customer_id
      # TODO
      # "ip_address"
      #  "ip_country_code"
      #  "vies_company_name"
      #  "vies_address"
     # "vies_request_identifier"
     )
  end

  def snapshot_card(card, invoice)
    invoice.update(
      card_brand: card.brand,
      card_last4: card.last4,
      card_country_code: card.country
      )
  end

  def ensure_invoice(stripe_id)
    sub = SubscriptionInvoice.where(stripe_id: stripe_id).first_or_initialize
    sub.user_id = @user.id
    sub.stripe_customer_id = @customer_id
    sub
  end

  def stripe_service
    @stripe_service ||= Subscription::Stripe.new(customer_id: @customer_id)
  end

  def vat_service
    @vat_service ||= VatService.new
  end
end
end
