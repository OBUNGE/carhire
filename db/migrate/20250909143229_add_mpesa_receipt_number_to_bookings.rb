class AddMpesaReceiptNumberToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :mpesa_receipt_number, :string
  end
end
