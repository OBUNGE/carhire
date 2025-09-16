class AddPaidAtToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :paid_at, :datetime
    add_column :bookings, :payment_transaction_id, :string
  end
end
