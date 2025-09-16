class AddRenterDetailsToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :renter_email, :string
    add_column :bookings, :renter_phone, :string
  end
end
