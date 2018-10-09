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

ActiveRecord::Schema.define(version: 20181008170544) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "cards", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "type",          limit: 255
    t.text     "text"
    t.integer  "quantity"
    t.string   "receiver",      limit: 255
    t.boolean  "send_to_donor",             default: false
    t.datetime "send_at"
    t.datetime "sent_at"
    t.string   "token",         limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "form_type",     limit: 255
    t.string   "job_id",        limit: 255
    t.string   "subtype"
  end

  add_index "cards", ["send_to_donor"], name: "index_cards_on_send_to_donor", using: :btree
  add_index "cards", ["token"], name: "index_cards_on_token", unique: true, using: :btree
  add_index "cards", ["type"], name: "index_cards_on_type", using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.string   "token",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["email"], name: "index_customers_on_email", using: :btree
  add_index "customers", ["token"], name: "index_customers_on_token", unique: true, using: :btree

  create_table "donors", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "donor_type",   limit: 255, default: "person"
    t.string   "first_name",   limit: 255
    t.string   "last_name",    limit: 255
    t.string   "email",        limit: 255
    t.string   "company",      limit: 255
    t.string   "org_number",   limit: 255
    t.string   "phone",        limit: 255
    t.text     "address"
    t.string   "post_code",    limit: 255
    t.string   "city",         limit: 255
    t.string   "country_code", limit: 255
    t.boolean  "newsletter",               default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "donors", ["donor_type"], name: "index_donors_on_donor_type", using: :btree

  create_table "examples", force: :cascade do |t|
    t.text     "description"
    t.integer  "amount"
    t.string   "country",     limit: 255
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "giftcards", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "category"
    t.string   "in_which_store"
    t.integer  "amount"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "thumbnail"
    t.string   "preview_swedish"
    t.string   "preview_english"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "quantity"
    t.string   "product"
    t.integer  "product_quantity"
    t.integer  "order_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "subtype"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "payment_type",               limit: 255, default: "card"
    t.string   "stripe_charge_id",           limit: 255
    t.datetime "paid_at"
    t.integer  "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
    t.integer  "digital_cards_count",                    default: 0
    t.integer  "analog_cards_count",                     default: 0
    t.integer  "analog_cards_regular_count",             default: 0
    t.integer  "analog_cards_xmas_count",                default: 0
    t.string   "swish_number"
    t.boolean  "added_to_kommed",                        default: false,  null: false
  end

  add_index "orders", ["payment_type"], name: "index_orders_on_payment_type", using: :btree

  create_table "purchase_histories", force: :cascade do |t|
    t.string   "donor",      limit: 255
    t.string   "token",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "swish_payments", force: :cascade do |t|
    t.string   "payment_id",              null: false
    t.jsonb    "info",       default: {}, null: false
    t.integer  "order_id",                null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "swish_payments", ["order_id"], name: "index_swish_payments_on_order_id", using: :btree

  add_foreign_key "swish_payments", "orders"
end
