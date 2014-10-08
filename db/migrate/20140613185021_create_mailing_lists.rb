class CreateMailingLists < ActiveRecord::Migration
  def change
    create_table :mailing_lists do |t|
      t.string :name, null: false
      t.integer :user_id, null: false
      t.timestamp :last_sent
      t.timestamp :segment_from
      t.timestamp :segment_to
    end
  end
end
