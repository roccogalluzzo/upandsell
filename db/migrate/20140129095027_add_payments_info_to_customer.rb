class AddPaymentsInfoToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :account_currency, :string, limit: 3
    add_column :customers, :email_paypal, :string
    add_column :customers, :paypal_status, :boolean
    add_column :customers, :credit_card_token, :string
    add_column :customers, :credit_card_status, :boolean
  end
end
