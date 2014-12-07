class AddStripeDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_token, :string
    add_column :users, :plan_type, :string
  end
end
