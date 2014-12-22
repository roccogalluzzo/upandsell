class AddCentsFieldToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :discount_money_cents, :integer
    add_column :coupons, :discount_money_currency, :integer

    add_index :coupons, :code
    add_index :coupons, :product_id
    add_index :coupons, :user_id
  end
end
