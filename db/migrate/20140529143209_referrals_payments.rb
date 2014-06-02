class ReferralsPayments < ActiveRecord::Migration
  def change
    create_table :referrals_payments do |t|
      t.integer :user_id
      t.integer :leads_paid
      t.string :payout
      t.string :payout_currency
      t.string :status
      t.string :payment_token
      t.datetime :payed_at
      t.timestamps
    end
  end
end
