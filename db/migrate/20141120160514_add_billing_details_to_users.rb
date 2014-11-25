class AddBillingDetailsToUsers < ActiveRecord::Migration
  def change
   add_column :users, :business_type, :string, default: 'private'
   add_column :users, :country, :string
   add_column :users, :legal_name, :string
   add_column :users, :tax_code, :string
   add_column :users, :city, :string
   add_column :users, :address, :string
   add_column :users, :province, :string
   add_column :users, :cap, :string
   add_column :users, :stripe_id, :string
 end
end
