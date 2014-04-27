class AddCctypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :cc_type, :string
  end
end
