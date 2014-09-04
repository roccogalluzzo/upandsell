class CreateInvite < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string   :email
      t.string   :invitation_token
      t.string   :status
      t.datetime :invitation_created_at
      t.datetime :invitation_sent_at
      t.datetime :invitation_accepted_at
    end

    add_index :invites, :invitation_token, :unique => true
    add_index :invites, :email, :unique => true
  end
end
