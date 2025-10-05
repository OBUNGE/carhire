require 'httparty'
require 'base64'

class MpesaService
  include HTTParty
  base_uri 'https://sandbox.safaricom.co.ke' # change to live URL in production

  def initialize
    @shortcode       = ENV.fetch('MPESA_SHORTCODE')
    @passkey         = ENV.fetch('MPESA_PASSKEY')
    @consumer_key    = ENV.fetch('MPESA_CONSUMER_KEY')
    @consumer_secret = ENV.fetch('MPESA_CONSUMER_SECRET')
    # ✅ Unified callback for both deposit & final
    @callback_url    = "#{ENV.fetch('APP_URL')}/payment/stk_callback"
    @token           = fetch_access_token
  end

  # === CUSTOMER PAYMENT (STK Push) ===
  def stk_push(booking:, amount:, phone_number:, account_reference: nil, callback_url: nil)
    sanitized_phone = sanitize_phone(phone_number)
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')

    payload = {
      BusinessShortCode: @shortcode,
      Password: generate_password(timestamp),
      Timestamp: timestamp,
      TransactionType: "CustomerPayBillOnline",
      Amount: amount.round,
      PartyA: sanitized_phone,
      PartyB: @shortcode,
      PhoneNumber: sanitized_phone,
      CallBackURL: callback_url || @callback_url,
      AccountReference: account_reference || "Booking#{booking.id}",
      TransactionDesc: "Payment for car rental"
    }

    response = self.class.post(
      '/mpesa/stkpush/v1/processrequest',
      headers: auth_headers,
      body: payload.to_json
    )

    Rails.logger.info "📲 STK Push response: #{response.code} #{response.body}"
    raise "M-Pesa STK Push failed: #{response.body}" unless response.code == 200

    response
  end

  # === OWNER PAYOUT (B2C) ===
  def b2c_payout(booking, amount)
    phone = sanitize_phone(booking.car.owner.phone_number)

    payload = {
      InitiatorName: ENV.fetch("MPESA_INITIATOR_NAME"),
      SecurityCredential: ENV.fetch("MPESA_SECURITY_CREDENTIAL"),
      CommandID: "BusinessPayment",
      Amount: amount.to_f.round,
      PartyA: @shortcode,
      PartyB: phone,
      Remarks: "Owner payout for Booking#{booking.id}",
      QueueTimeOutURL: "#{ENV.fetch('APP_URL')}/payment/timeout_callback",
      ResultURL: "#{ENV.fetch('APP_URL')}/payment/result_callback",
      Occasion: "Booking#{booking.id}"
    }

    response = self.class.post(
      "/mpesa/b2c/v1/paymentrequest",
      headers: auth_headers,
      body: payload.to_json
    )

    Rails.logger.info "✅ B2C payout response for Booking #{booking.id}: #{response.code} #{response.body}"
    raise "❌ B2C payout failed: #{response.body}" unless response.code == 200

    response
  end

  # === RENTER REFUND ===
  def refund_renter(booking)
    phone  = sanitize_phone(booking.renter.phone_number)
    amount = booking.total_paid.to_f.round

    payload = {
      Initiator: ENV.fetch("MPESA_INITIATOR_NAME"),
      SecurityCredential: ENV.fetch("MPESA_SECURITY_CREDENTIAL"),
      CommandID: "TransactionReversal",
      TransactionID: booking.mpesa_receipt_number,
      Amount: amount,
      ReceiverParty: @shortcode,
      ReceiverIdentifierType: "4",
      ResultURL: "#{ENV.fetch('APP_URL')}/payment/refund_result_callback",
      QueueTimeOutURL: "#{ENV.fetch('APP_URL')}/payment/refund_timeout_callback",
      Remarks: "Refund for Booking#{booking.id}",
      Occasion: "Booking#{booking.id}"
    }

    response = self.class.post(
      "/mpesa/reversal/v1/request",
      headers: auth_headers,
      body: payload.to_json
    )

    Rails.logger.info "↩️ Refund response for Booking #{booking.id}: #{response.code} #{response.body}"
    raise "❌ Refund failed: #{response.body}" unless response.code == 200

    response
  end

  private

  def fetch_access_token
    auth = { username: @consumer_key, password: @consumer_secret }
    response = self.class.get(
      '/oauth/v1/generate?grant_type=client_credentials',
      basic_auth: auth
    )
    JSON.parse(response.body)["access_token"] || raise("Failed to fetch M-Pesa token")
  end

  def generate_password(timestamp)
    Base64.strict_encode64("#{@shortcode}#{@passkey}#{timestamp}")
  end

  def sanitize_phone(phone)
    digits = phone.to_s.gsub(/\D/, '')
    digits = digits.sub(/^\+/, '')
    digits = digits.sub(/^0+/, '')
    digits.start_with?('254') ? digits : "254#{digits}"
  end

  def auth_headers
    {
      "Authorization" => "Bearer #{@token}",
      "Content-Type" => "application/json"
    }
  end
end
