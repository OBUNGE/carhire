class AddDetailsToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :make, :string
    add_column :cars, :model, :string
    add_column :cars, :year, :integer
    add_column :cars, :price, :decimal
    add_column :cars, :description, :text
  end
end
