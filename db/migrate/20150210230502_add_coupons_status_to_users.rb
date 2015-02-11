class AddCouponsStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :coupon_active, :string
  end
end
