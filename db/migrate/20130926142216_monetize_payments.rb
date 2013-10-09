class MonetizePayments < ActiveRecord::Migration
  def change

    add_money :payments, :amount
  end
end
