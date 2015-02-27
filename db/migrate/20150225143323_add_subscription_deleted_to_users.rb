class AddSubscriptionDeletedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscription_deleted, :boolean
  end
end
