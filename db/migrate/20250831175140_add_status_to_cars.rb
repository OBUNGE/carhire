class AddStatusToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :status, :string, default: "draft"
  end
end
