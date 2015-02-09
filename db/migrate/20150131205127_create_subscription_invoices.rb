class CreateSubscriptionInvoices < ActiveRecord::Migration
  def change
    create_table :subscription_invoices do |t|
      t.integer  :user_id, null: false
      t.string   :stripe_id, null: false
      t.string   :stripe_customer_id, null: false
      # Numbering
      t.integer  :year
      t.integer  :sequence_number
      t.string   :number

      # Invoice lifecycle
      t.boolean  :added_vat
      t.datetime :finalized_at
      t.datetime :reserved_at

       # Credit notes
       t.boolean :credit_note, default: false
       t.string  :reference_number

      # PDF generation
      t.datetime :pdf_generated_at

      # Amounts
      t.integer :subtotal
      t.integer :discount_amount
      t.integer :subtotal_after_discount
      t.integer :vat_amount
      t.decimal :vat_rate
      t.integer :total
      t.string  :currency

      # Used exchange rate and amounts in EUR
      t.decimal :exchange_rate_eur
      t.integer :vat_amount_eur
      t.integer :total_eur

      # Card used to pay the invoice
      t.string  :card_brand
      t.string  :card_last4
      t.string  :card_country_code

      # Snapshot of customer
      t.string  :customer_email
      t.string  :customer_name
      t.string  :customer_company_name
      t.string  :customer_country_code
      t.string  :customer_address
      t.boolean :customer_vat_registered
      t.string  :customer_vat_number
      t.string  :customer_accounting_id

      # GeoIP information
      t.string  :ip_address
      t.string  :ip_country_code

      # VIES information
      t.string  :vies_company_name
      t.string  :vies_address
      t.string  :vies_request_identifier

    end
    add_index :subscription_invoices, :stripe_id, unique: true
  end
end
