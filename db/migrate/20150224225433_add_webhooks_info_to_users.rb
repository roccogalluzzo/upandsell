class AddWebhooksInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :webhook_order_url, :string
    add_column :users, :webhook_refund_url, :string
  end
end
