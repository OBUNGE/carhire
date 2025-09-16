class AddTotalPriceToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :total_price, :decimal, precision: 10, scale: 2
  end
end
