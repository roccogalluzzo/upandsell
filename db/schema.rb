# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150301091521) do

  create_table "coupons", force: true do |t|
    t.integer  "product_id",                       null: false
    t.string   "code",                             null: false
    t.integer  "discount"
    t.integer  "available"
    t.integer  "used",                 default: 0
    t.datetime "expire"
    t.string   "discount_type"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "discount_money_cents", default: 0
  end

  add_index "coupons", ["code"], name: "index_coupons_on_code", using: :btree
  add_index "coupons", ["product_id"], name: "index_coupons_on_product_id", using: :btree
  add_index "coupons", ["user_id"], name: "index_coupons_on_user_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "invites", force: true do |t|
    t.string   "email"
    t.string   "invitation_token"
    t.string   "status"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
  end

  add_index "invites", ["email"], name: "index_invites_on_email", unique: true, using: :btree
  add_index "invites", ["invitation_token"], name: "index_invites_on_invitation_token", unique: true, using: :btree

  create_table "mailing_list_emails", force: true do |t|
    t.integer  "mailing_list_id"
    t.string   "subject"
    t.text     "content"
    t.datetime "sent_at"
  end

  add_index "mailing_list_emails", ["mailing_list_id"], name: "index_mailing_list_emails_on_mailing_list_id", using: :btree

  create_table "mailing_lists", force: true do |t|
    t.string   "name",                 null: false
    t.integer  "user_id",              null: false
    t.datetime "last_sent"
    t.datetime "segment_from"
    t.datetime "segment_to"
    t.string   "mailchimp_list_id"
    t.string   "mailchimp_list_name"
    t.string   "createsend_list_id"
    t.string   "createsend_list_name"
  end

  create_table "mailing_lists_products", force: true do |t|
    t.integer "mailing_list_id"
    t.integer "product_id"
  end

  add_index "mailing_lists_products", ["mailing_list_id", "product_id"], name: "index_mailing_lists_products_on_mailing_list_id_and_product_id", using: :btree
  add_index "mailing_lists_products", ["mailing_list_id"], name: "index_mailing_lists_products_on_mailing_list_id", using: :btree
  add_index "mailing_lists_products", ["product_id"], name: "index_mailing_lists_products_on_product_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "product_id",                              null: false
    t.string   "token",                                   null: false
    t.integer  "user_id",                                 null: false
    t.string   "email",                                   null: false
    t.string   "gateway",                                 null: false
    t.string   "gateway_token"
    t.text     "payment_details"
    t.integer  "amount_cents",            default: 0,     null: false
    t.string   "amount_currency",         default: "USD", null: false
    t.integer  "amount_base_cents",       default: 0,     null: false
    t.string   "status"
    t.integer  "n_downloads",             default: 0
    t.string   "cancel_reason"
    t.string   "ip"
    t.boolean  "buyer_accepts_marketing"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.datetime "cancelled_at"
    t.integer  "number"
    t.integer  "coupon_id"
  end

  add_index "orders", ["product_id"], name: "index_orders_on_product_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name",                           null: false
    t.text     "description"
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "USD", null: false
    t.string   "file_key",                       null: false
    t.text     "file_info"
    t.string   "slug",                           null: false
    t.integer  "user_id",                        null: false
    t.boolean  "published",      default: true
    t.string   "preview"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sales_limit"
    t.datetime "deleted_at"
  end

  add_index "products", ["deleted_at"], name: "index_products_on_deleted_at", using: :btree
  add_index "products", ["file_key"], name: "index_products_on_file_key", unique: true, using: :btree
  add_index "products", ["slug"], name: "index_products_on_slug", unique: true, using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "referrals", force: true do |t|
    t.integer  "referer_id"
    t.integer  "user_id"
    t.string   "amount"
    t.string   "status"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "referrals", ["user_id"], name: "index_referrals_on_user_id", using: :btree

  create_table "referrals_payments", force: true do |t|
    t.integer  "user_id"
    t.integer  "leads_paid"
    t.string   "payout"
    t.string   "payout_currency"
    t.string   "status"
    t.string   "payment_token"
    t.datetime "payed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_newsletters", force: true do |t|
    t.string   "subject"
    t.text     "content"
    t.datetime "sent_at"
    t.string   "target"
  end

  create_table "subscription_invoices", force: true do |t|
    t.integer  "user_id",                                                          null: false
    t.string   "stripe_id",                                                        null: false
    t.string   "stripe_customer_id",                                               null: false
    t.integer  "year"
    t.integer  "sequence_number"
    t.string   "number"
    t.boolean  "added_vat"
    t.datetime "finalized_at"
    t.datetime "reserved_at"
    t.boolean  "credit_note",                                      default: false
    t.string   "reference_number"
    t.datetime "pdf_generated_at"
    t.integer  "subtotal"
    t.integer  "discount_amount"
    t.integer  "subtotal_after_discount"
    t.integer  "vat_amount"
    t.decimal  "vat_rate",                precision: 10, scale: 0
    t.integer  "total"
    t.string   "currency"
    t.decimal  "exchange_rate_eur",       precision: 10, scale: 0
    t.string   "card_brand"
    t.string   "card_last4"
    t.string   "card_country_code"
    t.string   "customer_email"
    t.string   "customer_name"
    t.string   "customer_country_code"
    t.string   "customer_address"
    t.boolean  "customer_vat_registered"
    t.string   "customer_vat_number"
    t.string   "customer_accounting_id"
    t.string   "ip_address"
    t.string   "ip_country_code"
    t.string   "vies_company_name"
    t.string   "vies_address"
    t.string   "vies_request_identifier"
    t.string   "stripe_plan_id"
    t.datetime "invoice_period_start"
    t.datetime "invoice_period_end"
    t.string   "customer_city"
    t.string   "customer_cap"
    t.text     "invoice_lines"
  end

  add_index "subscription_invoices", ["stripe_id"], name: "index_subscription_invoices_on_stripe_id", using: :btree
  add_index "subscription_invoices", ["user_id"], name: "index_subscription_invoices_on_user_id", using: :btree

  create_table "subscription_payments", force: true do |t|
    t.integer  "user_id",                                 null: false
    t.string   "stripe_payment_id",                       null: false
    t.integer  "amount_due_cents",        default: 0,     null: false
    t.string   "amount_due_currency",     default: "USD", null: false
    t.datetime "payed_at"
    t.datetime "period_start"
    t.datetime "period_end"
    t.string   "status"
    t.string   "plan"
    t.datetime "created_at"
    t.string   "credit_card_bt_currency"
  end

  create_table "users", force: true do |t|
    t.string   "name",                                           null: false
    t.string   "email",                                          null: false
    t.string   "encrypted_password",                             null: false
    t.string   "currency",                                       null: false
    t.boolean  "credit_card",                default: false
    t.boolean  "paypal",                     default: false
    t.text     "credit_card_info"
    t.text     "paypal_info"
    t.boolean  "email_after_sale",           default: true
    t.string   "ga_code"
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "referer_id"
    t.string   "mailchimp_token"
    t.string   "createsend_token"
    t.text     "custom_email_message"
    t.string   "avatar"
    t.string   "bio"
    t.boolean  "newsletter",                 default: true
    t.string   "business_type",              default: "private"
    t.string   "country"
    t.string   "legal_name"
    t.string   "tax_code"
    t.string   "city"
    t.string   "address"
    t.string   "province"
    t.string   "zip_code"
    t.string   "stripe_id"
    t.string   "last_4_digits"
    t.boolean  "subscription_active"
    t.datetime "subscription_end"
    t.string   "cc_brand"
    t.string   "stripe_token"
    t.string   "plan_type"
    t.string   "credit_card_gateway"
    t.string   "credit_card_token"
    t.string   "credit_card_public_token"
    t.string   "credit_card_bt_merchant_id"
    t.string   "credit_card_bt_currency"
    t.string   "paypal_email"
    t.string   "paypal_token"
    t.string   "paypal_token_secret"
    t.string   "coupon_active"
    t.string   "webhook_order_url"
    t.string   "webhook_refund_url"
    t.boolean  "subscription_deleted"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
