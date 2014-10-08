class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
        t.integer  :product_id, null: false
        t.string   :token, null: false
        t.integer  :user_id, null: false
        t.string   :email, null: false
        t.string   :gateway, null: false
        t.string   :gateway_token
        t.text     :payment_details
        t.money    :amount
        t.money    :amount_base, currency: { present: false }
        t.string   :status
        t.integer  :n_downloads, default: 0
        t.string   :cancel_reason
        t.string   :ip
        t.boolean  :buyer_accepts_marketing
        t.timestamps
        t.datetime :completed_at
        t.datetime :cancelled_at
    end
end
end
