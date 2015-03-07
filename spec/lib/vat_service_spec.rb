require 'rails_helper'

describe VatService do

  let(:service) { VatService.new }

  describe '#calculate' do
    it 'calculates correct VAT amount' do
      expect(example(100, 'US', true).amount).to eq(0)
      expect(example(100, 'US', false).amount).to eq(0)

      expect(example(100, 'FR', true).amount).to eq(0)
      # TODO quando attivero' l'IVA dinamica dovra' uscire 20, per ora 22
      expect(example(100, 'FR', false).amount).to eq(22)

      expect(example(100, 'IT', false).amount).to eq(22)
      expect(example(100, 'IT', true).amount).to eq(22)

      # Rounded.
      expect(example(2010, 'IT', true).amount).to eq(442)
      expect(example(2060, 'IT', true).amount).to eq(453)

      # No country.
      expect(example(1000, nil, true).amount).to eq(0)
    end
  end

  describe '#validate' do
    it 'validates the VAT number' do
      VCR.use_cassette('service_validate_vat') do
        expect(service.valid?(vat_number: 'LU21416127')).to eq true
        expect(service.valid?(vat_number: 'IE6388047V')).to eq true
        expect(service.valid?(vat_number: 'LU21416128')).to eq false
      end
    end

    it 'validates the VAT number using the checksum' do
      allow(Valvat::Lookup).to receive(:validate) { nil }
      expect(service.valid?(vat_number: 'LU21416127')).to eq true
      expect(service.valid?(vat_number: 'IE6388047V')).to eq true
      expect(service.valid?(vat_number: 'LU21416128')).to eq false
    end
  end

  describe '#details' do
    it 'returns details about the VAT number' do
      VCR.use_cassette('details_vat', :record => :new_episodes) do
        details = service.details(vat_number: 'LU21416127')

        expect(details[:country_code]).to eq 'LU'
        expect(details[:vat_number]).to eq '21416127'
        expect(details[:name]).to eq 'EBAY EUROPE S.A R.L.'
        expect(details[:address]).to eq "22, BOULEVARD ROYAL\nL-2449  LUXEMBOURG"
        expect(details[:request_identifier]).to be_nil
      end
    end

    it 'returns details about the VAT number and a request identifier' do
      VCR.use_cassette('details_own_vat', :record => :new_episodes) do
        details = service.details(vat_number: 'LU21416127', own_vat: 'IE6388047V')

         expect(details[:country_code]).to eq 'LU'
         expect(details[:vat_number]).to eq '21416127'
         expect(details[:name]).to eq 'EBAY EUROPE S.A R.L.'
         expect(details[:address]).to eq "22, BOULEVARD ROYAL\nL-2449  LUXEMBOURG"
         expect(details[:request_identifier]).to be_truthy
      end
    end

    describe 'the VIES service is down' do
      it 'raises an error' do
         allow_any_instance_of(Valvat).to receive(:exists?) { nil }
        expect {service.details(vat_number: 'LU21416127')
        }.to raise_error(VatService::ViesDown)
      end
    end
  end

  def example amount, country_code, company
    service.calculate(
      amount: amount, country_code: country_code, vat_registered: company)
  end
end