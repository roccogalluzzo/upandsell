class AddCustomEmailMessageToUsers < ActiveRecord::Migration
  def change
   add_column :users, :custom_email_message, :text
 end
end
