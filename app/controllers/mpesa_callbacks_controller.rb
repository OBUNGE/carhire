class MpesaCallbacksController < ApplicationController
  # Skip CSRF and authentication for Safaricom callbacks, but don't raise if they aren't defined
  skip_before_action :verify_authenticity_token, raise: false
  skip_before_action :authenticate_user!, raise: false

  # === B2C payout result ===
  def result_callback
    Rails.logger.info "✅ B2C result callback received: #{request.body.read}"

    result  = params[:Result] || {}
    amount  = result.dig("ResultParameters", "ResultParameter")&.find { |p| p["Key"] == "TransactionAmount" }&.dig("Value")
    receipt = result.dig("ResultParameters", "ResultParameter")&.find { |p| p["Key"] == "TransactionReceipt" }&.dig("Value")

    # If you can link this payout to a booking:
    booking = Booking.find_by(id: 71) # TODO: match via stored payout reference

    if booking
      PaymentMailer.with(
        booking: booking,
        amount: amount,
        receipt: receipt
      ).owner_payout_email.deliver_later
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
    process_payment # no stage passed — auto‑detect will handle it
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
    return head(:not_found) unless booking

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
        payout_owner(booking, amount) # send deposit payout immediately

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
        payout_owner(booking, amount) # send final payment payout immediately
      end

      broadcast_updates(booking, stage)
      send_emails(booking, stage)

      Rails.logger.info "✅ #{stage.to_s.capitalize} payment processed for Booking ##{booking.id}"
    else
      Rails.logger.warn "⚠️ Payment failed for Booking ##{booking_id}"
    end

    head :ok
  end

  def payout_owner(booking, amount)
    response = MpesaService.new.b2c_payout(booking, amount)

    # Extract only the receipt string to avoid serialization errors
    receipt = response.parsed_response.dig("Result", "ResultParameters", "ResultParameter")
                      &.find { |p| p["Key"] == "TransactionReceipt" }&.dig("Value")

    PaymentMailer.with(
      booking: booking,
      amount: amount,
      receipt: receipt
    ).owner_payout_email.deliver_later
  end

  def broadcast_updates(booking, stage)
    # Update renter's view
    Turbo::StreamsChannel.broadcast_replace_to(
      booking.renter,
      target: "booking_actions_#{booking.id}",
      partial: "bookings/booking_actions",
      locals: { booking: booking, is_owner: false }
    )

    # Update owner's view
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
    ref = data.dig("Body", "stkCallback", "CallbackMetadata", "Item")
             &.find { |i| i["Name"] == "AccountReference" }&.dig("Value")
    ref.to_s.remove("Booking").to_i
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
