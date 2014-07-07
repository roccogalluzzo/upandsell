class AddSyncToMailingList < ActiveRecord::Migration
  def change
    add_column :mailing_lists, :mailchimp_list_id, :integer
    add_column :mailing_lists, :mailchimp_list_name, :string
    add_column :mailing_lists, :createsend_list_id, :integer
    add_column :mailing_lists, :createsend_list_name, :string
  end
end
