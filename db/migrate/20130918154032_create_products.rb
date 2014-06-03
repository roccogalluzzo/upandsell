class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string   :name, null: false
      t.text     :description
      t.money    :price
      t.string   :file_key, null: false
      t.text     :file_info
      t.string   :slug, null: false
      t.integer  :user_id, null: false
      t.boolean  :published, default: true
      t.string   :preview
      t.text     :description
      t.timestamps
    end

    add_index :products, :file_key, unique: true
    add_index :products, :slug, unique: true
    add_index :products, :user_id
  end
end
