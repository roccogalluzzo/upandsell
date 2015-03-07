require "rails_helper"

describe SubscriptionInvoice do

  let(:invoice) {create(:subscription_invoice)}
  let(:invoice_eu) {build(:subscription_invoice, customer_country_code: 'FR')}
  let(:invoice_finalized) {build(:subscription_invoice_finalized)}

  describe '#finalized?' do
    context 'when the invoice was finalized' do
      it { expect(invoice_finalized.finalized?).to eq(true) }
    end
    context 'when was not finalized' do
      it { expect(invoice.finalized?).to eq(false) }
    end
  end

  describe '#finalize!' do
    context 'when the invoice was finalized' do
      it 'raise an exception' do
        expect{invoice_finalized.finalize!}
        .to raise_error SubscriptionInvoice::AlreadyFinalized
      end
    end
    context 'when the invoice was not finalized' do
      it 'finalize the invoice' do
        expect(invoice.finalize!.finalized?).to eq true
      end
    end
    context 'when there already other finalized invoices' do
      it 'increment invoice counter' do
        invoice.finalize!
        invoice2 = create(:subscription_invoice)
        expect(invoice2.finalize!.sequence_number).to eq 2
      end
    end
  end

  describe '#vat?' do
    context 'when there vat added' do
      it { expect(build(:subscription_invoice, vat_amount: 10).vat?).to eq(true) }
    end
    context 'when there no vat added' do
      it { expect(build(:subscription_invoice, vat_amount: 0).vat?).to eq(false) }
    end
  end

  describe '#discount?' do
    context 'when there a discount' do
      it { expect(build(:subscription_invoice, discount_amount: 10).discount?).to eq(true) }
    end
    context 'when there no discounts' do
      it { expect(build(:subscription_invoice, discount_amount: 0).discount?).to eq(false) }
    end
  end

  describe '#eu?' do
    context 'when is an EU country' do
      it { expect(invoice_eu.eu?).to eq(true) }
    end
    context 'when is US country' do
      it { expect(invoice.eu?).to eq(false) }
    end
  end

  describe '#reverse_charge?' do
    context 'when is an EU country' do
      it { expect(build(:subscription_invoice_company_EU).reverse_charge?).to eq(true) }
    end
    context 'when is IT country' do
      it { expect(build(:subscription_invoice_company_IT).reverse_charge?).to eq(false) }
    end
    context 'when is US country' do
      it { expect(build(:subscription_invoice).reverse_charge?).to eq(false) }
    end
  end

  describe '#reverse_charge?' do
    context 'when is an EU country' do
      it { expect(build(:subscription_invoice_company_EU).reverse_charge?).to eq(true) }
    end
    context 'when is IT country' do
      it { expect(build(:subscription_invoice_company_IT).reverse_charge?).to eq(false) }
    end
    context 'when is US country' do
      it { expect(build(:subscription_invoice).reverse_charge?).to eq(false) }
    end
  end
end
