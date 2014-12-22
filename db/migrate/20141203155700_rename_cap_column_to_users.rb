class RenameCapColumnToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :cap, :zip_code
  end
end
