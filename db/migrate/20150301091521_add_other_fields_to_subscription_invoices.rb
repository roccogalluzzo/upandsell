class AddOtherFieldsToSubscriptionInvoices < ActiveRecord::Migration
  def change
    add_column :subscription_invoices, :stripe_plan_id, :string
    add_column :subscription_invoices, :invoice_period_start, :datetime
    add_column :subscription_invoices, :invoice_period_end, :datetime
    add_column :subscription_invoices, :customer_city, :string
    add_column :subscription_invoices, :customer_cap, :string
    add_column :subscription_invoices, :invoice_lines, :text

    remove_column :subscription_invoices, :customer_company_name, :string
    remove_column :subscription_invoices, :vat_amount_eur, :string
    remove_column :subscription_invoices, :total_eur, :string

    remove_index :subscription_invoices, name: 'index_subscription_invoices_on_stripe_id'
    add_index :subscription_invoices, :stripe_id
  end
end
