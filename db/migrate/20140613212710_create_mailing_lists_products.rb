class CreateMailingListsProducts < ActiveRecord::Migration
  def change
    create_table :mailing_lists_products do |t|
      t.integer :mailing_list_id
      t.integer :product_id
    end
  end
end
