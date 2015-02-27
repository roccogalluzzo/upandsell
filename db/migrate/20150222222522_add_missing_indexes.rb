   class AddMissingIndexes < ActiveRecord::Migration
      def change
        add_index :mailing_list_emails, :mailing_list_id
        add_index :mailing_lists_products, :mailing_list_id
        add_index :mailing_lists_products, :product_id
        add_index :mailing_lists_products, [:mailing_list_id, :product_id]
        add_index :orders, :product_id
        add_index :orders, :user_id
        add_index :referrals, :user_id
        add_index :subscription_invoices, :user_id
      end
    end