class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    car = Car.find(params[:car_id])
    current_user.favorites.create(car: car)
    redirect_back fallback_location: cars_path
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    favorite.destroy
    redirect_back fallback_location: cars_path
  end
end
