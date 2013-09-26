class AddCustomerIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :customer_id, :int
  end
end
