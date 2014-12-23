class AddSubscriptionDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscription_active, :boolean
    add_column :users, :subscription_end, :datetime
    add_column :users, :cc_brand, :string
  end
end
