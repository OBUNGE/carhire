class CarImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car_image
  before_action :authorize_car_owner!

  def destroy
    car = @car_image.car
    @car_image.destroy

    # If the deleted image was the cover, set a new one
    if @car_image.cover? && car.car_images.any?
      car.car_images.first.update(cover: true)
    end

    redirect_to edit_car_path(car), notice: "Image removed successfully."
  end

  def set_cover
    car = @car_image.car
    car.car_images.update_all(cover: false)
    @car_image.update(cover: true)

    redirect_to edit_car_path(car), notice: "Cover image updated."
  end

  private

  def set_car_image
    @car_image = CarImage.find(params[:id])
  end

  def authorize_car_owner!
    unless @car_image.car.owner == current_user
      redirect_to cars_path, alert: "Not authorized to modify this image."
    end
  end
end
