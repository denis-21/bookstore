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

ActiveRecord::Schema.define(version: 20150914095325) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "zipcode",    limit: 5
    t.string   "city"
    t.string   "phone",      limit: 12
    t.string   "country"
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "authors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "price",       precision: 5, scale: 2
    t.integer  "stock"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "author_id"
    t.string   "image"
    t.integer  "category_id"
  end

  add_index "books", ["author_id"], name: "index_books_on_author_id", using: :btree
  add_index "books", ["category_id"], name: "index_books_on_category_id", using: :btree

  create_table "books_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "book_id"
  end

  add_index "books_users", ["book_id"], name: "index_books_users_on_book_id", using: :btree
  add_index "books_users", ["user_id", "book_id"], name: "index_books_users_on_user_id_and_book_id", unique: true, using: :btree
  add_index "books_users", ["user_id"], name: "index_books_users_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "name"
    t.integer  "discount"
    t.date     "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string   "number",     limit: 16
    t.string   "exp_month",  limit: 2
    t.string   "exp_year",   limit: 4
    t.string   "cvv",        limit: 3
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "credit_cards", ["user_id"], name: "index_credit_cards_on_user_id", using: :btree

  create_table "deliveries", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",      precision: 5, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.decimal  "price",      precision: 5, scale: 2
    t.integer  "quantity"
    t.integer  "book_id"
    t.integer  "order_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "order_items", ["book_id"], name: "index_order_items_on_book_id", using: :btree
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.decimal  "total_price",         precision: 5, scale: 2
    t.string   "state",                                       default: "in_progress"
    t.datetime "completed_at"
    t.integer  "user_id"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.integer  "delivery_id"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.integer  "coupon_id"
  end

  add_index "orders", ["coupon_id"], name: "index_orders_on_coupon_id", using: :btree
  add_index "orders", ["delivery_id"], name: "index_orders_on_delivery_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.text     "review"
    t.integer  "rating"
    t.boolean  "status",     default: false
    t.integer  "book_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "ratings", ["book_id"], name: "index_ratings_on_book_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.string   "provider"
    t.string   "uid"
    t.integer  "shipping_address_id"
    t.integer  "billing_address_id"
  end

  add_index "users", ["billing_address_id"], name: "index_users_on_billing_address_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["shipping_address_id"], name: "index_users_on_shipping_address_id", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  add_foreign_key "addresses", "users"
  add_foreign_key "books", "authors"
  add_foreign_key "books", "categories"
  add_foreign_key "books_users", "books"
  add_foreign_key "books_users", "users"
  add_foreign_key "credit_cards", "users"
  add_foreign_key "order_items", "books"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "coupons"
  add_foreign_key "orders", "deliveries"
  add_foreign_key "orders", "users"
  add_foreign_key "ratings", "books"
  add_foreign_key "ratings", "users"
end
