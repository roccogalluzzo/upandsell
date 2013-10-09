class AddBasicFieldsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :name, :string
    add_column :payments, :email, :string
    add_column :payments, :paykey, :string
    add_column :payments, :date, :timestamp
    add_column :payments, :product_id, :integer
    add_column :payments, :completed, :boolean
  end
end
