class ChangeMlProvidersIdsToString < ActiveRecord::Migration
  def change
   change_column :mailing_lists, :mailchimp_list_id, :string
   change_column :mailing_lists, :createsend_list_id, :string
 end
end
