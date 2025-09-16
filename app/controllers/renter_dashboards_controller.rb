class RenterDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_non_renters

  def show
    # Active rentals: started but not yet ended
    @active_bookings = current_user.bookings
                                   .includes(:car)
                                   .where.not(rental_start_time: nil)
                                   .where(rental_end_time: nil)
                                   .order(rental_start_time: :asc)

    # Upcoming bookings: not started yet
    @upcoming_bookings = current_user.bookings
                                     .includes(:car)
                                     .where(rental_start_time: nil)
                                     .order(planned_return_at: :asc)

    # Past bookings: ended
    @past_bookings = current_user.bookings
                                 .includes(:car)
                                 .where.not(rental_end_time: nil)
                                 .order(rental_end_time: :desc)

    # Purchases — adjust logic as needed
    @upcoming_purchases = current_user.purchases
                                      .includes(:car)
                                      .where("created_at >= ?", 30.days.ago)
                                      .order(created_at: :desc)

    @past_purchases = current_user.purchases
                                  .includes(:car)
                                  .where("created_at < ?", 30.days.ago)
                                  .order(created_at: :desc)
  end

  private

  def redirect_non_renters
    redirect_to cars_path, alert: "Access denied." unless current_user&.user?
  end
end
