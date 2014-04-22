class AddGaCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ga_code, :string
  end
end
