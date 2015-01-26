class CreateSubscriptionPayments < ActiveRecord::Migration
  def change
    create_table :subscription_payments do |t|
      t.integer :user_id, null: false
      t.string :stripe_payment_id, null: false
      t.money :amount_due
      t.datetime :payed_at, default: nil
      t.datetime :period_start, default: nil
      t.datetime :period_end, default: nil
      t.string :status
    end
  end
end
