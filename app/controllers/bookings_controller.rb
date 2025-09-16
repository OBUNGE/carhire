class BookingsController < ApplicationController
  before_action :authenticate_user!

  # For renter flow
  before_action :set_car, only: [:new, :create]
  before_action :forbid_self_booking!, only: [:new, :create]

  # For actions on an existing booking
  before_action :set_booking, only: [
    :show, :destroy, :approve, :reject, :start_timer, :stop_timer,
    :edit_invoice, :update_invoice, :booking_actions
  ]

  # Owner-only actions
  before_action :authorize_owner!, only: [:approve, :reject, :start_timer, :stop_timer]

  # Renter-only action
  before_action :authorize_renter!, only: [:destroy]

  def index
    @bookings = current_user.bookings.includes(:car)
  end

  def new
    if @car.listing_type == "for_sale"
      redirect_to new_car_purchase_path(@car), alert: "This car is for sale, not for rent."
    else
      @booking = @car.bookings.new
    end
  end
def create
  if @car.listing_type == "for_sale"
    redirect_to new_car_purchase_path(@car), alert: "This car is for sale, not for rent."
    return
  end

  @booking = @car.bookings.build(booking_params)
  @booking.renter = current_user
  @booking.status ||= :pending

  renter = current_user
  @booking.renter_email = renter.email
  @booking.renter_phone = renter.phone_number if renter.respond_to?(:phone_number)

  if @car.listing_type == "rent"
    @booking.deposit_amount = @car.deposit_amount || 0
  end

  if @booking.save
    respond_to do |format|
      format.html { redirect_to booking_path(@booking), notice: "Booking confirmed!" }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "bookingModalContent",
          partial: "bookings/confirmation",
          locals: { booking: @booking }
        )
      end
    end
  else
    error_message = @booking.errors.full_messages.to_sentence

    respond_to do |format|
      format.html do
        redirect_to car_path(@car), alert: "Booking failed: #{error_message}"
      end

      format.turbo_stream do
        render turbo_stream: [
          # Remove the modal so it disappears
          turbo_stream.replace("bookingModal", ""),
          # Update the flash area on the car page
          turbo_stream.replace(
            "flash-messages",
            partial: "shared/flash",
            locals: { flash: { alert: "Booking failed: #{error_message}" } }
          )
        ]
      end
    end
  end
end


  def edit_invoice
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "booking_actions_#{@booking.id}",
          partial: "bookings/edit_invoice_form",
          locals: { booking: @booking }
        )
      end
    end
  end

  def show
  end

  def renter_dashboard
    @active_bookings = current_user.bookings
                                   .includes(:car)
                                   .where.not(rental_start_time: nil)
                                   .where(rental_end_time: nil)
                                   .order(rental_start_time: :asc)

    @my_bookings  = current_user.bookings.includes(:car).order(created_at: :desc)
    @my_purchases = current_user.purchases.includes(:car).order(created_at: :desc)

    @upcoming_bookings = @my_bookings
                           .where(rental_start_time: nil)
                           .order(planned_return_at: :asc)

    @past_bookings = @my_bookings
                       .where.not(rental_end_time: nil)
                       .order(rental_end_time: :desc)

    @upcoming_purchases = @my_purchases.where("created_at >= ?", 30.days.ago)
    @past_purchases     = @my_purchases.where("created_at < ?", 30.days.ago)
  end

  def owner_dashboard
    @cars = current_user.cars.order(created_at: :desc)

    @owner_bookings = Booking.joins(:car)
                             .where(cars: { owner_id: current_user.id })
                             .includes(:car, :renter)
                             .order(created_at: :desc)

    @owner_purchases = Purchase.joins(:car)
                               .where(cars: { owner_id: current_user.id })
                               .includes(:car, :user)
                               .order(created_at: :desc)
  end
def approve
  # Ensure booking is loaded and owner is authorized
  unless @booking && @booking.car.owner == current_user
    return respond_with_booking_error("You are not authorized to approve this booking.")
  end

  # Only allow approval if booking is in pending_deposit stage
  if @booking.pending_deposit?
    # Option 1: Just mark as pending deposit and let renter pay from dashboard
    @booking.update!(status: :pending_deposit)

    # Option 2 (optional): Trigger deposit STK Push immediately
    # MpesaService.new.stk_push(
    #   booking: @booking,
    #   amount: @booking.deposit_amount,
    #   phone_number: @booking.renter.phone_number,
    #   account_reference: "Booking#{@booking.id}",
    #   callback_url: mpesa_deposit_callback_url
    # )

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          # Replace booking actions area
          turbo_stream.replace(
            "booking_actions_#{@booking.id}",
            partial: "bookings/booking_actions",
            locals: { booking: @booking, is_owner: true }
          ),
          # Replace status line
          turbo_stream.replace(
            "booking_status_#{@booking.id}",
            partial: "bookings/status",
            locals: { booking: @booking }
          ),
          # Replace payment section for renter
          turbo_stream.replace(
            "booking_payment_#{@booking.id}",
            partial: "renters/booking_payment_status",
            locals: { booking: @booking }
          )
        ]
      end
      format.html { redirect_to owner_dashboard_path, notice: "Booking approved. Awaiting deposit payment." }
    end
  else
    respond_with_booking_error("Only bookings awaiting approval can be approved.")
  end
end



def reject
  # Ensure only the owner can reject
  unless @booking.car.owner == current_user
    return respond_with_booking_error("You are not authorized to reject this booking.")
  end

  # Only allow rejection if booking is still awaiting deposit (pre‑payment stage)
  if @booking.pending_deposit?
    @booking.update!(status: :cancelled)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          # Replace the booking actions area
          turbo_stream.replace(
            "booking_actions_#{@booking.id}",
            partial: "bookings/booking_actions",
            locals: { booking: @booking, is_owner: true }
          ),
          # Replace the status line
          turbo_stream.replace(
            "booking_status_#{@booking.id}",
            partial: "bookings/status",
            locals: { booking: @booking }
          ),
          # Optionally remove the booking card entirely from the owner's list
          turbo_stream.remove("booking_card_#{@booking.id}")
        ]
      end
      format.html { redirect_to owner_dashboard_path, notice: "Booking cancelled." }
    end
  else
    respond_with_booking_error("Only bookings awaiting approval can be cancelled.")
  end
end

def pay
  @booking = current_user.bookings.find(params[:id])

  # Combine country code + phone number from form
  raw_country_code = params[:country_code].to_s
  raw_phone_number = params[:phone_number].to_s

  # Sanitize: remove non-digits, strip leading zeros
  digits = raw_phone_number.gsub(/\D/, '').sub(/^0+/, '')
  phone_number = "#{raw_country_code}#{digits}"

  # Validate format for Kenyan Safaricom numbers
  unless phone_number.match?(/^2547\d{8}$/)
    redirect_to renter_dashboard_path, alert: "Please enter a valid Safaricom number in the format 7XXXXXXXX" and return
  end

  payment_type = params[:payment_type]

  case payment_type
  when "deposit"
    amount = @booking.deposit_amount.to_f
    @booking.update!(status: :pending_deposit)
    callback_url = "#{ENV.fetch('APP_URL')}/mpesa/deposit_callback"

  when "final"
    amount = @booking.final_amount.to_f
    @booking.update!(status: :awaiting_final_payment)
    callback_url = "#{ENV.fetch('APP_URL')}/mpesa/final_callback"

  else
    redirect_to renter_dashboard_path, alert: "Invalid payment type" and return
  end

  # Call STK Push and capture response
  response = MpesaService.new.stk_push(
    booking: @booking,
    amount: amount,
    phone_number: phone_number,
    account_reference: "Booking#{@booking.id}",
    callback_url: callback_url
  )

  # Store IDs for callback matching fallback
  @booking.update!(
    merchant_request_id: response["MerchantRequestID"],
    checkout_request_id: response["CheckoutRequestID"]
  )

  redirect_to renter_dashboard_path, notice: "#{payment_type.capitalize} payment request sent to #{phone_number}. Please check your phone."
end




def update_invoice
  @booking = current_user.owned_bookings.find(params[:id])

  if @booking.update(invoice_params)
    @booking.reload
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "booking_actions_#{@booking.id}", # match the div in your dashboard
          partial: "bookings/booking_actions",
          locals: { booking: @booking, is_owner: (@booking.car.owner == current_user) }
        )
      end
      format.html { redirect_to owner_dashboard_path, notice: "Invoice updated successfully." }
    end
  else
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "booking_actions_#{@booking.id}", # same target for the form
          partial: "bookings/edit_invoice_form",
          locals: { booking: @booking, is_owner: (@booking.car.owner == current_user) }
        ), status: :unprocessable_entity
      end
      format.html { redirect_to owner_dashboard_path, alert: "Failed to update invoice." }
    end
  end
end

def finalize_invoice
  @booking = current_user.owned_bookings.find(params[:id])

  @booking.update!(
    invoice_finalized_at: Time.current,
    status: :awaiting_final_payment, # <-- changed from :completed
    total_price: @booking.calculate_total_price,
    platform_commission: @booking.platform_commission
  )

  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        "booking_actions_#{@booking.id}",
        partial: "bookings/final_invoice",
        locals: { booking: @booking }
      )
    end
    format.html { redirect_to owner_dashboard_path, notice: "Invoice finalised and sent to renter." }
  end
end


  def destroy
    @booking.destroy
    redirect_to renter_dashboard_path, notice: "Booking cancelled."
  end

def start_timer
  unless @booking && @booking.car.owner == current_user
    return respond_with_booking_error("You are not authorized to start the timer.")
  end

  if @booking.rental_start_time.blank?
    planned_return_at = @booking.planned_return_at.presence ||
                        (@booking.planned_days.present? ? Time.current + @booking.planned_days.days : nil)

    @booking.update!(
      rental_start_time: Time.current,
      planned_return_at: planned_return_at,
      status: :active_rental # ✅ enum-safe status
    )
  end

  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        "booking_actions_#{@booking.id}",
        partial: "bookings/booking_actions",
        locals: { booking: @booking, is_owner: (@booking.car.owner == current_user) }
      )
    end
    format.html { redirect_back(fallback_location: owner_dashboard_path) }
  end
end


def stop_timer
  if @booking.rental_start_time.present? && @booking.rental_end_time.nil?
    @booking.update_columns(
      rental_end_time: Time.current,
      status: "completed" # mark as completed when stopping
    )
    @booking.reload
  end

  # Recalculate totals now that rental_end_time is set
  total_price = @booking.calculate_total_price
  platform_commission = @booking.platform_commission

  @booking.update_columns(
    total_price: total_price,
    platform_commission: platform_commission
  )

  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        "booking_actions_#{@booking.id}", # match the div in _booking_actions.html.erb
        partial: "bookings/booking_actions",
        locals: { booking: @booking, is_owner: (@booking.car.owner == current_user) }
      )
    end
    format.html { redirect_back(fallback_location: owner_dashboard_path) }
  end
end

def booking_actions
  @booking = current_user.owned_bookings.find(params[:id])

  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        "booking_actions_#{@booking.id}", # match the div in your dashboard
        partial: "bookings/booking_actions",
        locals: { booking: @booking, is_owner: (@booking.car.owner == current_user) }
      )
    end
    format.html { redirect_to owner_dashboard_path }
  end
end

private
def sanitize_phone(phone)
  return nil if phone.blank?
  digits = phone.gsub(/\D/, '') # remove non-digits
  if digits.start_with?('0')
    digits.sub(/^0/, '254')
  elsif digits.start_with?('+')
    digits.sub(/^\+/, '')
  else
    digits
  end
end

def respond_with_booking_error(message = nil)
  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        "booking_actions_#{@booking.id}",
        partial: "bookings/booking_error",
        locals: { booking: @booking, is_owner: (@booking.car.owner == current_user), message: message }
      ), status: :unprocessable_entity
    end
    format.html { redirect_to owner_dashboard_path, alert: message || @booking.errors.full_messages.to_sentence }
  end
end

  def invoice_params
    params.require(:booking).permit(
      :car_wash_fee,
      :damage_fee,
      :custom_adjustment,
      :overtime_fee_override
    )
  end

  def set_car
    @cars = current_user.cars
@cars = @cars.where(status: params[:status]) if params[:status].present?

    @car = Car.find(params[:car_id]) if params[:car_id].present?
  end

  def set_booking
  @booking = Booking.find(params[:id])
end

  def forbid_self_booking!
  if @car.owner == current_user
    redirect_to @car, alert: "You cannot rent your own car."
  end
end


  def authorize_owner!
  Rails.logger.info "DEBUG: booking_id=#{@booking&.id}, booking_owner_id=#{@booking&.car&.owner_id}, current_user_id=#{current_user.id}"
  unless @booking && @booking.car.owner_id == current_user.id
    redirect_to cars_path, alert: "Not authorized." and return
  end
end



  def authorize_renter!
    redirect_to cars_path, alert: "Not authorized." unless @booking.owner_id == current_user.id
  end

   def handle_deposit_payment
    # Trigger M‑Pesa STK Push for deposit
    MpesaService.new.stk_push(
      phone_number: full_phone_number,
      amount: @booking.deposit_amount,
      account_reference: "Booking#{@booking.id}",
      callback_url: mpesa_deposit_callback_url
    )

    # Update status so owner sees "Awaiting Deposit" → will change to "Ready for Pickup" on callback
    @booking.update!(status: :pending_deposit)

    redirect_to renter_dashboard_path, notice: "Deposit payment request sent to your phone."
  end

  def handle_final_payment
    # Trigger M‑Pesa STK Push for final amount
    MpesaService.new.stk_push(
      phone_number: full_phone_number,
      amount: @booking.final_amount,
      account_reference: "Booking#{@booking.id}",
      callback_url: mpesa_final_callback_url
    )

    # Update status so owner sees "Awaiting Final Payment" → will change to "Completed" on callback
    @booking.update!(status: :awaiting_final_payment)

    redirect_to renter_dashboard_path, notice: "Final payment request sent to your phone."
  end

  def full_phone_number
    "#{params[:country_code]}#{params[:phone_number]}"
  end

  def booking_params
    params.require(:booking).permit(
      :full_name,
      :contact_number,
      :special_requests,
      :terms,
      :start_time,
      :planned_return_at,
      :planned_days,
      :id_number,
      :purpose,
      :nationality,
      :delivery_method,
      :pickup_location,
      :has_driver,
      :owner_contact,
      :request_type,
      :owner_email,
      :owner_phone,
      :deposit_amount
    )
  end
end 