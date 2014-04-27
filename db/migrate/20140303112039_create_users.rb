class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "name", null: false
      t.text "settings" # payments, account settings go here
      t.timestamps
    end
  end
end
