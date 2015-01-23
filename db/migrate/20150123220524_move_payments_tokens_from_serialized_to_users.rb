class MovePaymentsTokensFromSerializedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit_card_gateway, :string
    add_column :users, :credit_card_token, :string
    add_column :users, :credit_card_public_token, :string
    add_column :users, :credit_card_bt_merchant_id, :string
    add_column :users, :credit_card_bt_currency, :string

    add_column :users, :paypal_email, :string
    add_column :users, :paypal_token, :string
    add_column :users, :paypal_token_secret, :string
  end
end
