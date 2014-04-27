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

ActiveRecord::Schema.define(version: 20140422175006) do

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "account_currency",       default: "USD"
    t.string   "email_paypal"
    t.boolean  "paypal_status"
    t.string   "credit_card_token"
    t.boolean  "credit_card_status"
    t.text     "gateway_info"
  end

  add_index "customers", ["email"], name: "index_customers_on_email", unique: true, using: :btree
  add_index "customers", ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true, using: :btree

  create_table "orders", force: true do |t|
    t.integer  "product_id",                             null: false
    t.string   "email"
    t.string   "name"
    t.string   "payment_type"
    t.string   "payment_token"
    t.integer  "amount_cents",       default: 0,         null: false
    t.string   "amount_currency",    default: "USD",     null: false
    t.string   "status",             default: "created"
    t.string   "token",                                  null: false
    t.integer  "n_downloads",        default: 0,         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cc_type"
    t.integer  "amount_base_cents",  default: 0,         null: false
    t.boolean  "email_subscription"
  end

  create_table "product_files", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumb_file_name"
    t.string   "thumb_content_type"
    t.integer  "thumb_file_size"
    t.datetime "thumb_updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "price_cents",        default: 0,     null: false
    t.string   "price_currency",     default: "USD", null: false
    t.string   "slug"
    t.text     "uuid"
    t.integer  "user_id"
    t.boolean  "published",          default: false
  end

  create_table "users", force: true do |t|
    t.string   "name",                                   null: false
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "currency",               default: "USD", null: false
    t.boolean  "credit_card",            default: false
    t.boolean  "paypal",                 default: false
    t.text     "credit_card_info"
    t.text     "paypal_info"
    t.boolean  "email_after_sale",       default: true
    t.string   "ga_code"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
