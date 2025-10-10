class AddImageUrlToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :image_url, :string
  end
end
