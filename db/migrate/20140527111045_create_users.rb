class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :name, null: false
      t.string   :email, default: "", null: false
      t.string   :encrypted_password, default: "", null: false
      t.string   :currency,               default: "USD", null: false
      t.boolean  :credit_card,            default: false
      t.boolean  :paypal,                 default: false
      t.text     :credit_card_info
      t.text     :paypal_info
      t.string   :subscription_token
      t.string   :account_type, default: 'base'
      t.boolean  :email_after_sale, default: true
      t.string   :ga_code
      t.text     :settings
      t.timestamps
      t.datetime :subscription_date

     ## Recoverable
     t.string   :reset_password_token
     t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

    end


    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
