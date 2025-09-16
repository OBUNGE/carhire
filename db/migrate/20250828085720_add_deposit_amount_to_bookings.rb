class AddDepositAmountToBookings < ActiveRecord::Migration[8.0]
def change
    add_column :bookings, :deposit_amount, :decimal, precision: 10, scale: 2
  end
end
