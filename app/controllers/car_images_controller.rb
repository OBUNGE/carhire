class CarImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car
  before_action :set_car_image, only: %i[destroy set_cover]
  before_action :authorize_car_owner!

  # DELETE /cars/:car_id/car_images/:id
  def destroy
    was_cover = @car_image.cover?
    file_url  = @car_image.image_url

    if @car_image.destroy
      # Clean up file from Supabase storage
      SupabaseStorageService.new.delete(file_url)

      # If the deleted image was the cover, set a new one
      if was_cover && @car.car_images.any?
        @car.car_images.first.update(cover: true)
      end

      redirect_to edit_car_path(@car), notice: "Image removed successfully."
    else
      redirect_to edit_car_path(@car), alert: "Failed to remove image."
    end
  end

  # PATCH /cars/:car_id/car_images/:id/set_cover
  def set_cover
    @car.car_images.update_all(cover: false)
    @car_image.update(cover: true)

    redirect_to edit_car_path(@car), notice: "Cover image updated."
  end

  # PATCH /cars/:car_id/car_images/reorder
  def reorder
    # params[:car_image_ids] is an array of IDs in the new order
    params[:car_image_ids].each_with_index do |id, index|
      @car.car_images.find(id).update(position: index + 1)
    end

    head :ok
  end

  private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def set_car_image
    @car_image = @car.car_images.find(params[:id])
  end

  def authorize_car_owner!
    redirect_to cars_path, alert: "Not authorized to modify this car's images." unless @car.owner == current_user
  end
end
