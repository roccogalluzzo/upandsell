class AddEmailSubscriptionToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :email_subscription, :boolean, default: true
  end
end
