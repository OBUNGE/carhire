class AddDepositPaidAtToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :deposit_paid_at, :datetime
    add_column :bookings, :deposit_transaction_id, :string
  end
end
