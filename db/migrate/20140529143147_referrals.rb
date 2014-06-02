class Referrals < ActiveRecord::Migration
  def change
     create_table :referrals do |t|
      t.integer :referer_id
      t.integer :user_id
      t.string :amount
      t.string :status
      t.datetime :completed_at
      t.timestamps
    end
  end
end
