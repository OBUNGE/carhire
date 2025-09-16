class AddSpecsToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :transmission_type, :string
    add_column :cars, :fuel_type, :string
    add_column :cars, :insurance_status, :string
    add_column :cars, :seats, :integer
  end
end
