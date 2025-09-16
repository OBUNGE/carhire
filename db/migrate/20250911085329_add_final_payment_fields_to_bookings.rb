class AddFinalPaymentFieldsToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :final_paid_at, :datetime
    add_column :bookings, :final_receipt_number, :string
  end
end
