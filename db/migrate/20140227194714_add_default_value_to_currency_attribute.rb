class AddDefaultValueToCurrencyAttribute < ActiveRecord::Migration
  def change
     change_column :customers, :account_currency, :string, default: :USD
  end
end
