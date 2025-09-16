class AddRentalTimerFieldsToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :rental_start_time, :datetime
    add_column :bookings, :rental_end_time, :datetime
  end
end
