class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :car, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.datetime :start_time
      t.datetime :planned_return_at
      t.integer  :planned_days                # from add_planned_days_to_bookings
      t.string   :id_number
      t.string   :owner_contact               # from add_owner_contact_to_bookings
      t.string   :request_type                # from add_request_type_to_bookings
      t.datetime :timer_start                  # from add_listing_type_to_cars_and_timer_fields...
      t.datetime :timer_end
      t.integer  :status, default: 0, null: false # merged from change_status/add_default_status

      t.timestamps
    end
  end
end
