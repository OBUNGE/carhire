class AddLocationToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :latitude, :float
    add_column :cars, :longitude, :float
    add_column :cars, :pickup_address, :string
  end
end
