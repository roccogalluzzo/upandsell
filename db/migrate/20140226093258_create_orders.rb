class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    t.integer  "product_id", null: false
    t.string   "email"
    t.string   "name"
    t.string   "payment_type"
    t.string   "payment_token"
    t.money    "amount"
    t.string   "status", default: 'created'
    t.string   "token", null: false
    t.integer  "n_downloads",  default: 0, null: false
    end
  end
end
