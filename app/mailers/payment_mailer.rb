class PaymentMailer < ApplicationMailer
  default from: "no-reply@carhire.com"

  def renter_payment_email
    @booking      = params[:booking]
    @stage        = params[:stage]
    @stage_label  = @stage == :deposit ? "deposit" : "final"

    mail(
      to: @booking.renter.email,
      subject: "Your #{@stage_label} payment for Booking ##{@booking.id} was received"
    )
  end

  def owner_payment_email
    @booking      = params[:booking]
    @stage        = params[:stage]
    @stage_label  = @stage == :deposit ? "deposit" : "final"

    mail(
      to: @booking.owner.email,
      subject: "You’ve received a #{@stage_label} payment for Booking ##{@booking.id}"
    )
  end

  def owner_payout_email
    @booking = params[:booking]
    @amount  = params[:amount]
    @receipt = params[:receipt]

    mail(
      to: @booking.owner.email,
      subject: "Payout Sent for Booking ##{@booking.id}"
    )
  end
end
