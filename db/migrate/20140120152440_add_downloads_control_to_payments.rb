class AddDownloadsControlToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :token, :string
    add_column :payments, :n_downloads, :integer, :null => false, :default => 0
  end
end
