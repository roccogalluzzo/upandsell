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

ActiveRecord::Schema.define(version: 20141206173626) do

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

  add_index "coupons", ["code"], name: "index_coupons_on_code"
  add_index "coupons", ["product_id"], name: "index_coupons_on_product_id"
  add_index "coupons", ["user_id"], name: "index_coupons_on_user_id"

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id"

  create_table "invites", force: true do |t|
    t.string   "email"
    t.string   "invitation_token"
    t.string   "status"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
  end

  add_index "invites", ["email"], name: "index_invites_on_email", unique: true
  add_index "invites", ["invitation_token"], name: "index_invites_on_invitation_token", unique: true

  create_table "mailing_list_emails", force: true do |t|
    t.integer  "mailing_list_id"
    t.string   "subject"
    t.text     "content"
    t.datetime "sent_at"
  end

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

  add_index "products", ["deleted_at"], name: "index_products_on_deleted_at"
  add_index "products", ["file_key"], name: "index_products_on_file_key", unique: true
  add_index "products", ["slug"], name: "index_products_on_slug", unique: true
  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "referrals", force: true do |t|
    t.integer  "referer_id"
    t.integer  "user_id"
    t.string   "amount"
    t.string   "status"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "users", force: true do |t|
    t.string   "name",                                       null: false
    t.string   "email",                                      null: false
    t.string   "encrypted_password",                         null: false
    t.string   "currency",                                   null: false
    t.boolean  "credit_card",            default: false
    t.boolean  "paypal",                 default: false
    t.text     "credit_card_info"
    t.text     "paypal_info"
    t.boolean  "email_after_sale",       default: true
    t.string   "ga_code"
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,         null: false
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
    t.boolean  "newsletter",             default: true
    t.string   "business_type",          default: "private"
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
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
