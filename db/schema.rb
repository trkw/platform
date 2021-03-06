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

ActiveRecord::Schema.define(version: 20140823125222) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "auctions", force: true do |t|
    t.datetime "starting_at"
    t.datetime "ending_at"
    t.string   "status"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "starting_bid"
    t.float    "bid_increment"
    t.float    "buy_out_bid"
    t.integer  "winning_buyer_id"
    t.integer  "winning_bidding_id"
    t.integer  "seller_id"
  end

  add_index "auctions", ["ending_at"], name: "index_auctions_on_ending_at", using: :btree
  add_index "auctions", ["seller_id"], name: "index_auctions_on_seller_id", using: :btree
  add_index "auctions", ["starting_at"], name: "index_auctions_on_starting_at", using: :btree
  add_index "auctions", ["status"], name: "index_auctions_on_status", using: :btree
  add_index "auctions", ["winning_bidding_id"], name: "index_auctions_on_winning_bidding_id", using: :btree
  add_index "auctions", ["winning_buyer_id"], name: "index_auctions_on_winning_buyer_id", using: :btree

  create_table "biddings", force: true do |t|
    t.float    "amount"
    t.integer  "user_id"
    t.integer  "auction_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     default: "active"
  end

  add_index "biddings", ["auction_id"], name: "index_biddings_on_auction_id", using: :btree
  add_index "biddings", ["product_id"], name: "index_biddings_on_product_id", using: :btree
  add_index "biddings", ["status"], name: "index_biddings_on_status", using: :btree
  add_index "biddings", ["user_id"], name: "index_biddings_on_user_id", using: :btree

  create_table "billings", force: true do |t|
    t.string   "card_number"
    t.date     "expiration_date"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.string   "vat_number"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "three_digit"
  end

  add_index "billings", ["user_id"], name: "index_billings_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.string   "type"
    t.string   "status"
    t.string   "link"
    t.integer  "auction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "medium"
  end

  add_index "notifications", ["auction_id"], name: "index_notifications_on_auction_id", using: :btree
  add_index "notifications", ["status"], name: "index_notifications_on_status", using: :btree
  add_index "notifications", ["type"], name: "index_notifications_on_type", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.integer  "auction_id"
    t.integer  "product_id"
    t.integer  "bidding_id"
    t.integer  "assignee_id"
    t.string   "assignee_email"
    t.string   "status"
    t.integer  "zendesk_ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "buyer_rating_id"
    t.integer  "seller_rating_id"
  end

  add_index "orders", ["buyer_rating_id"], name: "index_orders_on_buyer_rating_id", using: :btree
  add_index "orders", ["seller_rating_id"], name: "index_orders_on_seller_rating_id", using: :btree

  create_table "product_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
  end

  add_index "product_categories", ["ancestry"], name: "index_product_categories_on_ancestry", using: :btree
  add_index "product_categories", ["name"], name: "index_product_categories_on_name", using: :btree

  create_table "product_images", force: true do |t|
    t.integer  "product_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "country"
    t.string   "volume"
    t.string   "size"
    t.string   "quality"
    t.float    "bidding"
    t.datetime "ending_at"
    t.datetime "delivery_at"
    t.text     "shipping_information"
    t.text     "packaging_information"
    t.string   "pallets"
    t.datetime "starting_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "product_category_id"
    t.text     "description"
  end

  add_index "products", ["country"], name: "index_products_on_country", using: :btree
  add_index "products", ["delivery_at"], name: "index_products_on_delivery_at", using: :btree
  add_index "products", ["ending_at"], name: "index_products_on_ending_at", using: :btree
  add_index "products", ["name"], name: "index_products_on_name", using: :btree
  add_index "products", ["product_category_id"], name: "index_products_on_product_category_id", using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "ratings", force: true do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.float    "stars"
    t.text     "review"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "auction_id"
  end

  add_index "ratings", ["auction_id"], name: "index_ratings_on_auction_id", using: :btree
  add_index "ratings", ["from_user_id"], name: "index_ratings_on_from_user_id", using: :btree
  add_index "ratings", ["stars"], name: "index_ratings_on_stars", using: :btree
  add_index "ratings", ["to_user_id"], name: "index_ratings_on_to_user_id", using: :btree

  create_table "sellers", force: true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "seller_logo"
    t.string   "seller_cover"
  end

  add_index "sellers", ["user_id"], name: "index_sellers_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                        default: "",     null: false
    t.string   "encrypted_password",           default: "",     null: false
    t.string   "name"
    t.string   "occupation"
    t.string   "address_street"
    t.string   "address_country"
    t.string   "address_city"
    t.string   "address_zip"
    t.string   "phone_number"
    t.string   "fax_number"
    t.string   "link"
    t.string   "logo"
    t.string   "user_type"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",              default: 0,      null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "buyer_type",                   default: "free"
    t.float    "rating_average"
    t.string   "provider"
    t.string   "uid"
    t.string   "shipping_type"
    t.text     "shipping_custom_instructions"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["rating_average"], name: "index_users_on_rating_average", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["user_type"], name: "index_users_on_user_type", using: :btree

end
