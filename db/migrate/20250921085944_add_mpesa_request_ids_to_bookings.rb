class AddMpesaRequestIdsToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :merchant_request_id, :string
    add_column :bookings, :checkout_request_id, :string
  end
end
