class RemoveImageUrlsFromCars < ActiveRecord::Migration[8.0]
   def change
    remove_column :cars, :image_urls, :string, array: true, default: []
  end
end
