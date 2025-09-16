class MpesaCallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
  skip_before_action :authenticate_user!, raise: false

  # === B2C payout result ===
  def result_callback
    raw_body = request.body.read
    Rails.logger.info "✅ B2C result callback received: #{raw_body}"

    result  = params[:Result] || {}
    amount  = result.dig("ResultParameters", "ResultParameter")
                    &.find { |p| p["Key"] == "TransactionAmount" }&.dig("Value")
    receipt = result.dig("ResultParameters", "ResultParameter")
                    &.find { |p| p["Key"] == "TransactionReceipt" }&.dig("Value")

    # Match booking via Occasion (set in MpesaService.b2c_payout)
    occasion    = result.dig("ResultParameters", "ResultParameter")
                        &.find { |p| p["Key"] == "Occasion" }&.dig("Value")
    booking_id  = occasion.to_s.remove("Booking").to_i
    booking     = Booking.find_by(id: booking_id)

    if booking
      PaymentMailer.with(
        booking: booking,
        amount: amount,
        receipt: receipt
      ).owner_payout_email.deliver_later
    else
      Rails.logger.warn "⚠️ B2C result callback could not match booking. Occasion: #{occasion.inspect}"
    end

    head :ok
  end

  # === B2C payout timeout ===
  def timeout_callback
    Rails.logger.warn "⚠️ B2C timeout callback received: #{request.body.read}"
    head :ok
  end

  # === Unified STK Push callback (deposit or final)
  def payment_callback
    process_payment
  end

  private

  def process_payment(stage: nil)
    raw_body = request.body.read
    return head(:bad_request) if raw_body.blank?

    data = JSON.parse(raw_body) rescue nil
    return head(:bad_request) unless data

    Rails.logger.info "✅ M‑Pesa #{stage || 'auto-detect'} callback: #{data.to_json}"

    booking_id = extract_booking_id(data)
    booking    = Booking.find_by(id: booking_id)

    unless booking
      Rails.logger.warn "⚠️ Payment callback received but booking not found. Data: #{data.inspect}"
      return head(:ok) # Prevent Safaricom retries
    end

    # Auto‑detect stage if not explicitly given
    if stage.nil?
      if booking.deposit_paid_at.blank?
        stage = :deposit
      elsif booking.final_paid_at.blank?
        stage = :final
      else
        Rails.logger.warn "⚠️ Duplicate payment callback for Booking ##{booking.id} — ignoring"
        return head(:ok)
      end
    end

    if data.dig("Body", "stkCallback", "ResultCode") == 0
      receipt = extract_transaction_id(data)
      amount  = extract_amount(data)

      if stage == :deposit
        booking.update!(
          deposit_paid_at: Time.current,
          deposit_transaction_id: receipt,
          status: :ready_for_pickup
        )
        payout_owner(booking, amount)

      elsif stage == :final
        if booking.start_time.present? && booking.start_time.future?
          Rails.logger.warn "⚠️ Final payment received before rental start — holding status at ready_for_pickup"
          booking.update!(
            final_paid_at: Time.current,
            final_receipt_number: receipt
          )
        else
          booking.update!(
            final_paid_at: Time.current,
            final_receipt_number: receipt,
            status: :completed
          )
        end
        payout_owner(booking, amount)
      end

      broadcast_updates(booking, stage)
      send_emails(booking, stage)

      Rails.logger.info "✅ #{stage.to_s.capitalize} payment processed for Booking ##{booking.id}"
    else
      Rails.logger.warn "⚠️ Payment failed for Booking ##{booking.id}"
    end

    head :ok
  end

  def payout_owner(booking, amount)
    response = MpesaService.new.b2c_payout(booking, amount)
    receipt  = response.parsed_response.dig("Result", "ResultParameters", "ResultParameter")
                        &.find { |p| p["Key"] == "TransactionReceipt" }&.dig("Value")

    PaymentMailer.with(
      booking: booking,
      amount: amount,
      receipt: receipt
    ).owner_payout_email.deliver_later
  end

  def broadcast_updates(booking, stage)
    Turbo::StreamsChannel.broadcast_replace_to(
      booking.renter,
      target: "booking_actions_#{booking.id}",
      partial: "bookings/booking_actions",
      locals: { booking: booking, is_owner: false }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      booking.owner,
      target: "booking_actions_#{booking.id}",
      partial: "bookings/booking_actions",
      locals: { booking: booking, is_owner: true }
    )
  end

  def send_emails(booking, stage)
    PaymentMailer.with(booking: booking, stage: stage).renter_payment_email.deliver_later
    PaymentMailer.with(booking: booking, stage: stage).owner_payment_email.deliver_later
  end

  # === Helpers to extract data from M‑Pesa payload ===
  def extract_booking_id(data)
    # Try AccountReference first
    ref = data.dig("Body", "stkCallback", "CallbackMetadata", "Item")
             &.find { |i| i["Name"] == "AccountReference" }&.dig("Value")
    return ref.to_s.remove("Booking").to_i if ref.present?

    # Fallback to MerchantRequestID / CheckoutRequestID
    merchant_id = data.dig("Body", "stkCallback", "MerchantRequestID")
    checkout_id = data.dig("Body", "stkCallback", "CheckoutRequestID")

    Booking.find_by(merchant_request_id: merchant_id)&.id ||
      Booking.find_by(checkout_request_id: checkout_id)&.id
  end

  def extract_transaction_id(data)
    data.dig("Body", "stkCallback", "CallbackMetadata", "Item")
        &.find { |i| i["Name"] == "MpesaReceiptNumber" }&.dig("Value")
  end

  def extract_amount(data)
    data.dig("Body", "stkCallback", "CallbackMetadata", "Item")
        &.find { |i| i["Name"] == "Amount" }&.dig("Value").to_f
  end
end
