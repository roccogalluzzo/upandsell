class AddOrderNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :number, :integer
  end
end
