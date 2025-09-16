class AddInvoiceFinalizedAtToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :invoice_finalized_at, :datetime
  end
end
