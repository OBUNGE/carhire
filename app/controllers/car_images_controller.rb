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
      SupabaseStorageService.new.delete(file_url)

      # If the deleted image was the cover, set a new one
      if was_cover && @car.car_images.any?
        @car.car_images.first.update(cover: true)
      end

      respond_to do |format|
        format.html { redirect_to edit_car_path(@car), notice: "Image removed successfully." }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_car_path(@car), alert: "Failed to remove image." }
        format.json { render json: { error: "Failed to remove image" }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /cars/:car_id/car_images/:id/set_cover
  def set_cover
    @car.car_images.update_all(cover: false)
    @car_image.update(cover: true)

    respond_to do |format|
      format.html { redirect_to edit_car_path(@car), notice: "Cover image updated." }
      format.json { head :ok }
    end
  end

  # PATCH /cars/:car_id/car_images/reorder
  def reorder
    params[:car_image_ids].each_with_index do |id, index|
      @car.car_images.find(id).update(position: index + 1)
    end

    respond_to do |format|
      format.html { head :ok }
      format.json { head :ok }
    end
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
