class OwnersController < ApplicationController
  before_action :set_owner

  def contact
    # You can preload the car(s) they own if needed
    @cars = @owner.cars
  end

  private

  def set_owner
    @owner = User.find(params[:id])
  end
end
