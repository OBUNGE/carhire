class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    # Remove first_name and last_name if already added
    # Only add phone if it's missing
    add_column :users, :phone, :string unless column_exists?(:users, :phone)
  end
end
