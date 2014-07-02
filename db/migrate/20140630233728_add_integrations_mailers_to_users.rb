class AddIntegrationsMailersToUsers < ActiveRecord::Migration
  def change
   add_column :users, :mailchimp_token, :string
   add_column :users, :campaign_monitor_token, :string
 end
end
