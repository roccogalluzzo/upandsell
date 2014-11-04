class ChangeCentsFieldToCoupons < ActiveRecord::Migration
  def change
    change_column :coupons, :discount_money_cents, :integer, default: 0
    remove_column :coupons, :discount_money_currency
  end
end
