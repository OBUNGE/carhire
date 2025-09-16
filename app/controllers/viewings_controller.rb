class ViewingsController < ApplicationController
  before_action :set_booking

  def new
    @viewing = @booking.build_viewing   # if Booking has_one :viewing
    # or @viewing = @booking.viewings.build  # if Booking has_many :viewings
  end

  def create
    @viewing = @booking.build_viewing(viewing_params) # or .viewings.build(...)
    if @viewing.save
      redirect_to booking_path(@booking), notice: "Viewing scheduled successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def viewing_params
    params.require(:viewing).permit(:scheduled_date, :notes)
  end
end
