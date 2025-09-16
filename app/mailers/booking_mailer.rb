class BookingMailer < ApplicationMailer
  default from: "no-reply@carhire.co.ke"

  def payment_received_renter(booking)
    @booking = booking
    mail(to: booking.renter.email, subject: "Payment Received for Booking ##{booking.id}")
  end

  def payment_received_owner(booking)
    @booking = booking
    mail(to: booking.car.owner.email, subject: "You’ve Been Paid for Booking ##{booking.id}")
  end
end
