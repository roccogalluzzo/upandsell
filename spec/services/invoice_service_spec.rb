require 'rails_helper'

describe Subscription::Invoice, stripe: true do

  let(:metadata) {{
    country_code: 'NL',
    vat_registered: 'false',
    vat_number: 'NL123',
    accounting_id: '10001',
    other: 'random'
    }}

    let(:plan) do
      VCR.use_cassette("service_invoice_create_plan", :record => :new_episodes) do
        begin
          Stripe::Plan.retrieve('test')
        rescue
          Stripe::Plan.create \
          id: 'test',
          name: 'Test Plan',
          amount: 1499,
          currency: 'eur',
          interval: 'month'
        end
      end
    end

    before do
      @user = create(:active_user)
    end

    describe '#ensure_vat' do
      it 'is idempotent' do
        VCR.use_cassette("service_invoice_ensure_vat") do
          @user.stripe_token  = Stripe::Token.create(
            :card => {
              :number => "4242424242424242",
              :exp_month => 2,
              :exp_year => 2016,
              :cvc => "314"
              },
              ).id
          @user.save
          customer = @user.create_subscription
          service = Subscription::Invoice.new(customer_id: customer.id)

          Stripe::InvoiceItem.create \
          customer: customer.id,
          amount: 100,
          currency: 'eur'

        # Apply VAT on the upcoming invoice.
        stripe_invoice = Stripe::Invoice.create(customer: customer.id)

        invoice = service.ensure_vat(stripe_invoice_id: stripe_invoice.id)
        expect(invoice).to be_kind_of(SubscriptionInvoice)
        expect(invoice.added_vat?).to eq true

        # Apply again.
        service.ensure_vat(stripe_invoice_id: stripe_invoice.id)
        invoice = customer.invoices.data.first
        expect(invoice.total).to eq 122

        expect(@user.subscription_invoices.count).to eq 1
        invoice = @user.subscription_invoices.first
        expect(invoice.added_vat?).to eq true
      end
    end
    it 'rescue stripe already finalizaded invoice' do
      VCR.use_cassette("service_invoice_ensure_stripe_error") do
        @user.stripe_token  = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 2,
            :exp_year => 2016,
            :cvc => "314"
            },
            ).id
        @user.save
        customer = @user.create_subscription
        service = Subscription::Invoice.new(customer_id: customer.id)

        Stripe::InvoiceItem.create \
        customer: customer.id,
        amount: 100,
        currency: 'eur'

        stripe_invoice = Stripe::Invoice.create(customer: customer.id)
        stripe_invoice.closed = true
        stripe_invoice.save

        invoice = service.ensure_vat(stripe_invoice_id: stripe_invoice.id)
        expect(invoice).to be_kind_of(SubscriptionInvoice)
        expect(invoice.added_vat?).to eq false
      end
    end
  end

  describe '#process_payment' do

    it 'finalizes the invoice' do
      VCR.use_cassette('service_invoice_finalize') do
       @user.stripe_token  = Stripe::Token.create(
        :card => {
          :number => "4242424242424242",
          :exp_month => 2,
          :exp_year => 2016,
          :cvc => "314"
          },
          ).id
       @user.save
       customer = @user.create_subscription
       service = Subscription::Invoice.new(customer_id: customer.id)

       Stripe::InvoiceItem.create \
       customer: customer.id,
       amount: 100,
       currency: 'eur'

       stripe_invoice = Stripe::Invoice.create(customer: customer.id)
       service.ensure_vat(stripe_invoice_id: stripe_invoice.id)

        # Pay the invoice before processing the payment.
        stripe_invoice.pay

        invoice = service.process_payment(stripe_invoice_id: stripe_invoice.id)
        expect(invoice.finalized?).to eq true

        expect(invoice.subtotal).to eq 100
        expect(invoice.discount_amount).to eq 0
        expect(invoice.subtotal_after_discount).to eq 100
        expect(invoice.vat_amount).to eq 22
        expect(invoice.vat_rate).to eq 22
        expect(invoice.total).to eq 122
        expect(invoice.currency).to eq 'eur'
        expect(invoice.customer_country_code).to eq 'IT'
        expect(invoice.customer_vat_number).to eq '12345678'
        expect(invoice.stripe_customer_id).to eq customer.id
        expect(invoice.customer_vat_registered).to eq false
        expect(invoice.card_brand).to eq 'Visa'
        expect(invoice.card_last4).to eq '4242'
        expect(invoice.card_country_code).to eq 'US'
      end
    end

    describe 'when the total amount is zero' do
      it 'does not finalize the invoice' do
        VCR.use_cassette('service_invoice_process_payment_zero') do
         @user.stripe_token  = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 2,
            :exp_year => 2016,
            :cvc => "314"
            },
            ).id
         @user.save
         customer = @user.create_subscription
         service = Subscription::Invoice.new(customer_id: customer.id)

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
    VCR.use_cassette('service_invoice_process_refund_orphan') do
      expect {
       @user.stripe_token  = Stripe::Token.create(
        :card => {
          :number => "4242424242424242",
          :exp_month => 2,
          :exp_year => 2016,
          :cvc => "314"
          },
          ).id
       @user.save
       customer = @user.create_subscription
       service = Subscription::Invoice.new(customer_id: customer.id)
       service.process_refund(stripe_invoice_id: 'xyz') }.to raise_error Subscription::Invoice::OrphanRefund
     end
   end

   describe 'when it is a real refund' do
    it 'creates a credit note' do
      VCR.use_cassette('service_invoice_process_refund') do
       @user.stripe_token  = Stripe::Token.create(
        :card => {
          :number => "4242424242424242",
          :exp_month => 2,
          :exp_year => 2016,
          :cvc => "314"
          },
          ).id
       @user.save
       customer = @user.create_subscription
       service = Subscription::Invoice.new(customer_id: customer.id)

       Stripe::InvoiceItem.create \
       customer: customer.id,
       amount: 100,
       currency: 'eur'

       stripe_invoice = Stripe::Invoice.create(customer: customer.id)

        # Pay the invoice before processing the payment.
        stripe_invoice.pay

        invoice = service.process_payment(stripe_invoice_id: stripe_invoice.id)

        credit_note = service.process_refund(stripe_invoice_id: stripe_invoice.id)
        expect(credit_note.finalized?).to eq true
      end
    end
  end

  describe '#load_vies_data' do
    it 'loads vies data into an invoice' do
      VCR.use_cassette('service_load_vies_data') do

        invoice = @user.subscription_invoices
        .create(
          customer_vat_number: 'LU21416127',
          stripe_id: 'stripe_id',
          stripe_customer_id: 'stripe_id')

        service = Subscription::Invoice.new(customer_id: 'stripe_id')


        service.load_vies_data(invoice: invoice)

        invoice = invoice.reload

        expect(invoice.vies_company_name).to  eq 'EBAY EUROPE S.A R.L.'
        expect(invoice.vies_address).to  eq "22, BOULEVARD ROYAL\nL-2449  LUXEMBOURG"
        expect(invoice.vies_request_identifier).not_to be_nil
      end
    end
  end
end
end