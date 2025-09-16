class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_non_owners

  def show
    # Cars owned by this user
    @cars = current_user.cars
    @total_cars = @cars.count
    @average_price = @cars.average(:price)

    # Bookings for those cars — newest first
    @owner_bookings = Booking.joins(:car)
                             .where(cars: { owner_id: current_user.id })
                             .includes(:car, :renter)
                             .order(created_at: :desc)

    # Purchases for those cars — newest first
    @owner_purchases = Purchase.joins(:car)
                               .where(cars: { owner_id: current_user.id })
                               .includes(:car, :user)
                               .order(created_at: :desc)
      @cars = current_user.cars.order(created_at: :desc)                           
  end

  private

  def redirect_non_owners
    redirect_to cars_path, alert: "Access denied." unless current_user.owner?
  end
end
