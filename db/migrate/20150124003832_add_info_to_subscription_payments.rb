class AddInfoToSubscriptionPayments < ActiveRecord::Migration
  def change

    add_column :subscription_payments, :plan, :string
    add_column :subscription_payments, :created_at, :datetime
    add_column :subscription_payments, :credit_card_bt_currency, :string
  end
end
