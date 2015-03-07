class SubscriptionInvoice < ActiveRecord::Base
  belongs_to :user

  scope :finalized, -> { where.not finalized_at: nil }

  AlreadyFinalized = Class.new(StandardError)

  # TK what about finalizing 2 invoices at the same time?
  # TK only finalize when vat was added?
  def finalize!
    raise AlreadyFinalized if finalized?
    # update the invoice.
    update self.class.next_sequence
    self
  end

  def finalized?
    !finalized_at.nil?
  end

  def due_at
    # finalized_at + Configuration.due_days.days
  end

  def discount?
    discount_amount && discount_amount != 0
  end

  def vat?
    vat_amount && vat_amount != 0
  end

  def eu?
    Valvat::Utils::EU_COUNTRIES.include?(customer_country_code)
  end

  def reverse_charge?
    return false if self.customer_country_code == 'IT'
    self.customer_vat_registered && Valvat::Utils::EU_COUNTRIES.include?(customer_country_code)
  end

  private

  def self.next_sequence
    year = Time.now.year
    sequence_number = next_sequence_number(year)

    # Number is a formatted version of this.
    number = AppSettings.invoice_number_format % { year: year, sequence: sequence_number.to_s.rjust(3, '0') }
    {
      year: year,
      sequence_number: sequence_number,
      number: number,
      finalized_at: Time.now
    }
  end

  def self.next_sequence_number(year)
    last_invoice =  SubscriptionInvoice
    .where.not(number: nil)
    .where(year: year)
    .order(:finalized_at)
    .last

    if last_invoice
      last_invoice.sequence_number + 1
    else
      1
    end
  end
end
