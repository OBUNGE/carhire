class AddPlatformCommissionToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :platform_commission, :decimal, precision: 10, scale: 2
  end
end