# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_07_155329) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.bigint "user_id", null: false
    t.datetime "start_time"
    t.datetime "planned_return_at"
    t.integer "planned_days"
    t.string "id_number"
    t.string "owner_contact"
    t.string "request_type"
    t.datetime "timer_start"
    t.datetime "timer_end"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "purpose"
    t.string "nationality"
    t.string "delivery_method"
    t.string "pickup_location"
    t.boolean "has_driver"
    t.string "renter_email"
    t.string "renter_phone"
    t.datetime "rental_start_time"
    t.datetime "rental_end_time"
    t.decimal "deposit_amount", precision: 10, scale: 2
    t.datetime "invoice_finalized_at"
    t.decimal "total_price"
    t.decimal "car_wash_fee"
    t.decimal "damage_fee", precision: 10, scale: 2, default: "0.0"
    t.decimal "custom_adjustment", precision: 10, scale: 2, default: "0.0"
    t.decimal "overtime_fee_override", precision: 10, scale: 2, default: "0.0"
    t.decimal "custom_fee", precision: 10, scale: 2, default: "0.0"
    t.decimal "platform_commission", precision: 10, scale: 2
    t.datetime "deposit_paid_at"
    t.string "deposit_transaction_id"
    t.datetime "paid_at"
    t.string "payment_transaction_id"
    t.string "full_name"
    t.string "contact_number"
    t.text "special_requests"
    t.boolean "terms"
    t.string "mpesa_receipt"
    t.string "mpesa_receipt_number"
    t.datetime "final_paid_at"
    t.string "final_receipt_number"
    t.string "merchant_request_id"
    t.string "checkout_request_id"
    t.index ["car_id"], name: "index_bookings_on_car_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "cars", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id", null: false
    t.string "make"
    t.string "model"
    t.integer "year"
    t.decimal "price"
    t.text "description"
    t.string "listing_type"
    t.string "name"
    t.decimal "deposit_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "pickup_address"
    t.string "category"
    t.string "status"
    t.string "transmission_type"
    t.string "fuel_type"
    t.string "insurance_status"
    t.integer "seats"
    t.index ["owner_id"], name: "index_cars_on_owner_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "car_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_favorites_on_car_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "car_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_purchases_on_car_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "car_id", null: false
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_reviews_on_car_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "phone"
    t.string "phone_number"
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "viewings", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.datetime "scheduled_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_viewings_on_booking_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "cars"
  add_foreign_key "bookings", "users"
  add_foreign_key "cars", "users", column: "owner_id"
  add_foreign_key "favorites", "cars"
  add_foreign_key "favorites", "users"
  add_foreign_key "purchases", "cars"
  add_foreign_key "purchases", "users"
  add_foreign_key "reviews", "cars"
  add_foreign_key "reviews", "users"
  add_foreign_key "viewings", "bookings"
end
