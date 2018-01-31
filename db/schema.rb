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

ActiveRecord::Schema.define(version: 20180127200016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "name"
    t.string "body"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "cards", force: :cascade do |t|
    t.string "last_four_numbers", null: false
    t.string "token", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "expiration_date", null: false
    t.string "card_type"
    t.integer "card_type_code"
    t.string "issuer"
    t.string "issuer_bank_country"
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "dispatcher_admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_dispatcher_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_dispatcher_admin_users_on_reset_password_token", unique: true
  end

  create_table "drivers", force: :cascade do |t|
    t.string "phone_number", null: false
    t.string "encrypted_password", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "licence_plate"
    t.string "photo"
    t.string "car_model"
    t.string "surname"
    t.float "balance"
    t.string "license"
    t.integer "points"
    t.boolean "confirmed", default: false
    t.float "rating"
    t.integer "status", default: 0
    t.boolean "bonus_on_this_week", default: false
    t.bigint "tariff_id"
    t.string "car_color"
    t.index ["phone_number"], name: "index_drivers_on_phone_number", unique: true
    t.index ["tariff_id"], name: "index_drivers_on_tariff_id"
  end

  create_table "order_options", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.float "price"
  end

  create_table "order_options_orders", id: false, force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "order_option_id", null: false
    t.index ["order_id", "order_option_id"], name: "index_order_options_orders_on_order_id_and_order_option_id"
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "lat_from"
    t.decimal "lon_from"
    t.decimal "lat_to"
    t.decimal "lon_to"
    t.bigint "user_id"
    t.bigint "driver_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment"
    t.integer "rating"
    t.float "amount"
    t.string "address_from"
    t.string "address_to"
    t.float "distance"
    t.integer "waiting_minutes"
    t.datetime "time_of_taking"
    t.datetime "start_waiting_time"
    t.datetime "time_of_starting"
    t.datetime "time_of_closing"
    t.string "intermediate_points", default: [], array: true
    t.integer "payment_method"
    t.bigint "tariff_id"
    t.integer "removing_status", default: 0
    t.string "review"
    t.index ["driver_id"], name: "index_orders_on_driver_id"
    t.index ["intermediate_points"], name: "index_orders_on_intermediate_points", using: :gin
    t.index ["tariff_id"], name: "index_orders_on_tariff_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "description"
    t.float "amount"
    t.jsonb "data"
    t.bigint "user_id"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.integer "card_id"
    t.integer "payment_method"
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "price_settings", force: :cascade do |t|
    t.integer "singleton_guard", null: false
    t.float "waiting_price", null: false
    t.float "price_per_kilometer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "percentage_of_driver"
    t.integer "free_waiting_minutes"
    t.float "driver_rate_increase_by_orders"
    t.float "max_driver_rate"
    t.float "driver_rate_increase_by_rating"
    t.float "coef_for_economy"
    t.float "coef_for_comfort"
    t.float "min_order_amount"
    t.float "driver_rate_increase_by_photo"
    t.index ["singleton_guard"], name: "index_price_settings_on_singleton_guard", unique: true
  end

  create_table "senior_dispatcher_admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_senior_dispatcher_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_senior_dispatcher_admin_users_on_reset_password_token", unique: true
  end

  create_table "tariffs", force: :cascade do |t|
    t.float "waiting_price"
    t.float "price_per_kilometer"
    t.float "percentage_of_driver"
    t.integer "free_waiting_minutes"
    t.float "driver_rate_increase_by_orders"
    t.float "max_driver_rate"
    t.float "driver_rate_increase_by_rating"
    t.float "min_order_amount"
    t.float "driver_rate_increase_by_photo"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "status", default: 0
    t.integer "priority"
    t.integer "max_commission"
    t.float "night_price_per_kilometer"
  end

  create_table "users", force: :cascade do |t|
    t.string "phone_number", null: false
    t.string "encrypted_password", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sex"
    t.string "surname"
    t.integer "status", default: 0
    t.string "favorite_addresses", default: ""
    t.string "photo"
    t.string "email"
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

  add_foreign_key "drivers", "tariffs"
  add_foreign_key "orders", "tariffs"
end
