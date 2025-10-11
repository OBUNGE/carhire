class AddPositionToCarImages < ActiveRecord::Migration[8.0]
  def change
    add_column :car_images, :position, :integer
  end
end
