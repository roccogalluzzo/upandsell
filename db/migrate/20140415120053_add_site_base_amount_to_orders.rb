class AddSiteBaseAmountToOrders < ActiveRecord::Migration
  def change
    add_money :orders, :amount_base, currency: { present: false }
  end
end
