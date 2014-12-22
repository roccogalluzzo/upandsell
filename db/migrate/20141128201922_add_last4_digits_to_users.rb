class AddLast4DigitsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_4_digits, :string
  end
end
