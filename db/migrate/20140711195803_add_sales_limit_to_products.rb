class AddSalesLimitToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sales_limit, :integer
  end
end
