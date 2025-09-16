class AddInvoiceFieldsToBookings < ActiveRecord::Migration[8.0]
def change
    add_column :bookings, :damage_fee, :decimal, precision: 10, scale: 2, default: 0
    add_column :bookings, :custom_adjustment, :decimal, precision: 10, scale: 2, default: 0
    add_column :bookings, :overtime_fee_override, :decimal, precision: 10, scale: 2, default: 0 
  end
end