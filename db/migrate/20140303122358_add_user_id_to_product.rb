class AddUserIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :user_id, :int
  end
end
