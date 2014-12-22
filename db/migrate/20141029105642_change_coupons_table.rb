class ChangeCouponsTable < ActiveRecord::Migration
  def change
   rename_column :coupons, :avaiable, :available
   rename_column :coupons, :type, :discount_type
   add_column :coupons, :user_id, :integer
 end
end
