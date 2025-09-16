class AddFullNameToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :full_name, :string
    add_column :bookings, :contact_number, :string
    add_column :bookings, :special_requests, :text
    add_column :bookings, :terms, :boolean
  end
end
