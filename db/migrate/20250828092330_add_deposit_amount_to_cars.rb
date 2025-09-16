class AddDepositAmountToCars < ActiveRecord::Migration[8.0]
  def change
    # migration
      add_column :bookings, :deposit_paid_at, :datetime
      add_column :bookings, :deposit_transaction_id, :string

    add_column :cars, :deposit_amount, :decimal, precision: 10, scale: 2, default: 0, null: false
  end
end