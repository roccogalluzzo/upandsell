class AddUuidToProducts < ActiveRecord::Migration
  def change
    add_column :products, :uuid, :text
  end
end
