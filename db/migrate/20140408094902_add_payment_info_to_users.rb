class AddPaymentInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :currency, :string, default: "USD", null: false
    add_column :users, :credit_card, :boolean, default: false
    add_column :users, :paypal, :boolean, default: false
    add_column :users, :credit_card_info, :text
    add_column :users, :paypal_info, :text
  end
end
