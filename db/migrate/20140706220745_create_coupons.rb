class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.integer :product_id, null: false
      t.string :code, null: false
      t.integer :discount
      t.integer :avaiable, default: nil
      t.integer :used, default: 0
      t.datetime :expire, default: nil
      t.string :type
      t.string :status
    end
  end
end
