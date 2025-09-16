class AddPurposeAndExtrasToBookings < ActiveRecord::Migration[8.0]
  def change
    #add_column :bookings, :purpose, :string
    add_column :bookings, :nationality, :string
    add_column :bookings, :delivery_method, :string
    add_column :bookings, :pickup_location, :string
    add_column :bookings, :has_driver, :boolean
  end
end
