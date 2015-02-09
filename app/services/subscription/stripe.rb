class Subscription::Stripe

  def self.create_customer(user)
    @plans = {'monthly' => 'MONTHLY_PLAN', 'yearly' => 'YEARLY_PLAN'}
    if user.tax_code && user.business_type == 'company'
      vat = true
    else
      vat = false
    end

    @customer = Stripe::Customer.create(
      card: user.stripe_token,
      email: user.email,
      metadata: {
        id: user.id,
        country_code: user.country,
        vat_registered: vat,
        name: user.legal_name,
        address: user.address,
        type: user.business_type,
        vat_number: user.tax_code,
        },
        plan: @plans[user.plan_type],
        trial_end: user.trial_end
        )

    @customer
  end

  def initialize(customer_id:)
    @customer_id = customer_id
    @plans = {'monthly' => 'MONTHLY_PLAN', 'yearly' => 'YEARLY_PLAN'}
  end

  def subscribe(new_plan, token)
   if !self.is_subscribed?
    customer.subscriptions.create({plan: @plans[new_plan], card: token})
  end
end

def change_plan(new_plan)
  if self.is_subscribed?
    subscription = customer.subscriptions.retrieve(customer.subscriptions.data[0].id)
    subscription.plan = @plans[new_plan]
    subscription.prorate = false
    subscription.save
  end
rescue Stripe::StripeError => e
  Rails.logger.error "Stripe Error: " + e.message
  false
end

def change_card(token)
  customer.card = token
  customer.save

rescue Stripe::StripeError => e
  Rails.logger.error "Stripe Error: " + e.message
  false
end

def cancel_subscription
  byebug
  subscription = customer.subscriptions.data[0]
  customer.subscriptions.retrieve(subscription.id).delete(at_period_end: true).cancel_at_period_end

rescue Stripe::StripeError => e
  Rails.logger.error "Stripe Error: " + e.message
  false
end

def is_subscribed?
  subscription = customer.subscriptions.data[0]
  if subscription && (subscription.status == 'trialing' || subscription.status == 'active')
    return true
  end
  false
end

  # Applies VAT to a Stripe invoice if necessary.
  # Copies customer metadata to the invoice, to make it immutable
  # for the invoice (in case the customer's metadata changes).
  #
  # invoice - A Stripe invoice object.
  #
  # Returns the finalized stripe invoice.
  def apply_vat(invoice_id:)
    stripe_invoice = Stripe::Invoice.retrieve(invoice_id)

    # Add VAT to the invoice.
    vat, invoice_item = charge_vat(stripe_invoice.subtotal,
      invoice_id: invoice_id, currency: stripe_invoice.currency)

    Stripe::Invoice.retrieve(invoice_id)
  end

  # Calculates the final correct state of an invoice. It
  # figures out the right amount of VAT and discount.
  #
  # stripe_invoice - The Stripe invoice to calculate.
  #
  # Returns a hash that contains all calculated data.
  def calculate_final(stripe_invoice:)
    # Find the VAT invoice item.
    vat_line = stripe_invoice.lines.find { |line| line.metadata[:type] == 'vat' }
    other_lines = stripe_invoice.lines.to_a - [vat_line]
    subtotal = other_lines.map(&:amount).inject(:+)
    total = stripe_invoice.total

    # Recalculate discount based on the sum of all lines besides the vat line.
    discount = calculate_discount(subtotal, calculate_vat_rate, total) if stripe_invoice.discount

    # we do #to_i here because discount can be nil.
    subtotal_after_discount = subtotal - discount.to_i

    # If there is vat and a discount, we need to recalculate VAT and the discount.
    calculation = if vat_line && stripe_invoice.discount
      # Recalculate VAT based on the total after discount
      vat_amount, vat_rate = calculate_vat(subtotal_after_discount).to_a

      {
        discount_amount: discount,
        subtotal_after_discount: subtotal_after_discount,
        vat_amount: vat_amount,
        vat_rate: vat_rate
      }
    else
      {
        discount_amount: stripe_invoice.subtotal - stripe_invoice.total,
        subtotal_after_discount: subtotal_after_discount,
        vat_amount: (vat_line && vat_line.amount).to_i,
        vat_rate: (vat_line && vat_line.metadata[:rate]).to_i
      }
    end

    calculation.merge! \
    subtotal: subtotal,
    total: stripe_invoice.total,
    currency: stripe_invoice.currency
  end

  def customer_metadata
    customer.metadata.to_h.merge!(email: customer.email)
  end

  def customer
    @customer ||= Stripe::Customer.retrieve(@customer_id)
  end

  private

  def last_invoice
    Stripe::Invoice.all(customer: customer.id, limit: 1).first
  end

  def charge_vat_of_plan(plan)
    # Add vat charges.
    charge_vat(plan.amount, currency: plan.currency)
  end

  # Charges VAT for a certain amount.
  #
  # amount - Amount to charge VAT for.
  # invoice_id - optional invoice_id (upcoming invoice by default).
  #
  # Returns a VatCharge object.
  def charge_vat(amount, currency:, invoice_id: nil)
    # Calculate the amount of VAT to be paid.
    vat = calculate_vat(amount)

    # Add an invoice item to the invoice with this amount.
    invoice_item = Stripe::InvoiceItem.create(
      customer: customer.id,
      invoice: invoice_id,
      amount: vat.amount,
      currency: currency,
      description: "VAT (#{vat.rate}%)",
      metadata: {
        type: 'vat',
        rate: vat.rate
      }
      ) unless vat.amount.zero?

    [vat, invoice_item]
  end

  def calculate_vat(amount)
    vat_service.calculate \
    amount: amount,
    country_code: customer.metadata[:country_code],
    vat_registered: (customer.metadata[:vat_registered] == 'true')
  end

  def calculate_vat_rate
    vat_service.vat_rate \
    country_code: customer.metadata[:country_code],
    vat_registered: (customer.metadata[:vat_registered] == 'true')
  end


  # Calculates the amount of discount given on an amount
  # with a certain Stripe coupon.
  #
  # We calculate discount using this formula:
  # d = [ s*( 1 + vr ) - t ] / ( 1 + vr )
  # where s is the amount, vr the VAT rate and t the total amount.
  #
  # Returns discount rounded up to 1 cent.
  def calculate_discount(s, vat_rate, t)
    vr = vat_rate/100.0

    d = (s * (1 + vr) - t)/(1 + vr)
    d.round
  end

  def vat_service
    @vat_service ||= VatService.new
  end
end
