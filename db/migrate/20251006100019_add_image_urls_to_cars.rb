class AddImageUrlsToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :image_urls, :text
  end
end
