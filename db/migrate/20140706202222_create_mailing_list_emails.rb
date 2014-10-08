class CreateMailingListEmails < ActiveRecord::Migration
  def change
    create_table :mailing_list_emails do |t|
      t.integer :mailing_list_id
      t.string :subject
      t.text :content
      t.datetime :sent_at
    end
  end
end
