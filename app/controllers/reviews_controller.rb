class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car

  def create
    @review = @car.reviews.build(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @car, notice: "Review added."
    else
      redirect_to @car, alert: "Error adding review."
    end
  end

  private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
