# app/controllers/admin/bookings_controller.rb
module Admin
  class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    def index
      @bookings = Booking.includes(:renter, car: :owner).order(created_at: :desc)

      case params[:filter]
      when "refundable"
        @bookings = @bookings.select(&:refundable?)
      when "unpaid"
        @bookings = @bookings.reject(&:paid_at)
      when "pending_payout"
        @bookings = @bookings.select { |b| b.owner_payout.nil? }
      end

      @bookings = @bookings.first(50)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def refund
      booking = Booking.find(params[:id])
      if booking.refundable?
        MpesaService.new.refund_renter(booking)
        flash.now[:notice] = "Refund initiated for Booking ##{booking.id}"
      else
        flash.now[:alert] = "Booking ##{booking.id} cannot be refunded."
      end
      reload_table
    end

    def payout
      booking = Booking.find(params[:id])
      MpesaService.new.b2c_payout(booking)
      flash.now[:notice] = "Payout initiated for Booking ##{booking.id}"
      reload_table
    end

    private

    def reload_table
      @bookings = Booking.includes(:renter, car: :owner).order(created_at: :desc).first(50)
      respond_to do |format|
        format.html { redirect_to admin_bookings_path }
        format.turbo_stream { render "admin/bookings/update_table" }
      end
    end

    def require_admin!
      redirect_to root_path unless current_user&.admin?
    end
  end
end
