class RenameUserIdToOwnerIdInCars < ActiveRecord::Migration[8.0]
  def change
    rename_column :cars, :user_id, :owner_id
  end
end
