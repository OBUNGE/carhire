class AddCustomFeeToBookings < ActiveRecord::Migration[8.0]
 def change
    add_column :bookings, :custom_fee, :decimal, precision: 10, scale: 2, default: 0
  end
end
