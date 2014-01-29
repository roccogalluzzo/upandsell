class AddPaymillInfoToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :gateway_info, :text
  end
end
