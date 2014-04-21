class AddEmailAfterSaleToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_after_sale, :boolean, default: true
  end
end
