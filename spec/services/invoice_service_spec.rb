require 'rails_helper'

describe Subscription::Invoice do

  let(:metadata) {{
    country_code: 'NL',
    vat_registered: 'false',
    vat_number: 'NL123',
    accounting_id: '10001',
    other: 'random'
    }}
    let(:stripe_helper) { StripeMock.create_test_helper }

    let(:plan) do
      begin
        Stripe::Plan.retrieve('test')
      rescue
        Stripe::Plan.create \
        id: 'test',
        name: 'Test Plan',
        amount: 1499,
        currency: 'usd',
        interval: 'month'
      end
    end

    let(:customer) do
      Stripe::Customer.create \
      card: {
        number: '4242424242424242',
        exp_month: '12',
        exp_year: '30',
        cvc: '222'
        },
        metadata: metadata
      end
      let(:user) do
        create(:user)
      end

      let(:service) { Subscription::Invoice.new(customer_id: customer.id, user_id: user.id) }

      describe '#ensure_vat' do
        it 'is idempotent' do
         VCR.use_cassette('apply_vat_idempotent') do
          Stripe::InvoiceItem.create \
          customer: customer.id,
          amount: 100,
          currency: 'usd'

        # Apply VAT on the upcoming invoice.
        stripe_invoice = Stripe::Invoice.create(customer: customer.id)

        invoice = service.ensure_vat(stripe_invoice_id: stripe_invoice.id)
        expect(invoice).to be_kind_of(SubscriptionInvoice)
        expect(invoice.added_vat?).to eq true

        # Apply again.
        service.ensure_vat(stripe_invoice_id: stripe_invoice.id)

        invoice = customer.invoices.first
        expect(invoice.total).to eq 121

        expect(SubscriptionInvoice.count).to eq 1
        invoice = SubscriptionInvoice.first
        expect(invoice.added_vat?).to eq true
      end
    end
  end

  describe '#process_payment' do

    it 'finalizes the invoice' do
      VCR.use_cassette('process_payment') do
        Stripe::InvoiceItem.create \
        customer: customer.id,
        amount: 100,
        currency: 'usd'

        stripe_invoice = Stripe::Invoice.create(customer: customer.id)

        service.ensure_vat(stripe_invoice_id: stripe_invoice.id)

        # Pay the invoice before processing the payment.
        stripe_invoice.pay

        invoice = service.process_payment(stripe_invoice_id: stripe_invoice.id)
        expect(invoice.finalized?).to eq true

         expect(invoice.subtotal).to eq 100
         expect(invoice.discount_amount).to eq 0
         expect(invoice.subtotal_after_discount).to eq 100
         expect(invoice.vat_amount).to eq 21
         expect(invoice.vat_rate).to eq 21
         expect(invoice.total).to eq 121
         expect(invoice.currency).to eq 'usd'
         expect(invoice.customer_country_code).to eq 'NL'
         expect(invoice.customer_vat_number).to eq 'NL123'
         expect(invoice.stripe_customer_id).to eq customer.id
         expect(invoice.customer_vat_registered).to eq false
         expect(invoice.card_brand).to eq 'Visa'
         expect(invoice.card_last4).to eq '4242'
         expect(invoice.card_country_code).to eq 'US'
      end
    end

    describe 'when the total amount is zero' do
      it 'does not finalize the invoice' do
        VCR.use_cassette('process_payment_zero') do
          customer.subscriptions.create(plan: plan.id, trial_end: (Time.now.to_i + 1000))
          stripe_invoice = customer.invoices.first
          invoice = service.process_payment(stripe_invoice_id: stripe_invoice.id)
          expect(invoice.finalized?).to eq false
        end
      end
    end
  end

  describe '#process_refund' do

    it 'is an orphan refund' do
      VCR.use_cassette('process_refund_orphan') do
        expect { service.process_refund(stripe_invoice_id: 'xyz') }.to raise_error Subscription::Invoice::OrphanRefund
      end
    end

    describe 'when it is a real refund' do
      it 'creates a credit note' do
        VCR.use_cassette('process_refund') do
          Stripe::InvoiceItem.create \
          customer: customer.id,
          amount: 100,
          currency: 'usd'

          stripe_invoice = Stripe::Invoice.create(customer: customer.id)

        # Pay the invoice before processing the payment.
        stripe_invoice.pay

        invoice = service.process_payment(stripe_invoice_id: stripe_invoice.id)

        credit_note = service.process_refund(stripe_invoice_id: stripe_invoice.id)
        expect(credit_note.credit_note).to eq true
      end
    end
  end
end
end