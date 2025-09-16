class Booking < ApplicationRecord
  # === ASSOCIATIONS ===
  belongs_to :car
  belongs_to :renter, class_name: "User", foreign_key: "user_id"
  has_one :owner, through: :car
  has_one :viewing

  # === VALIDATIONS ===
  validates :start_time, :planned_return_at, :id_number, presence: { message: "is required" }
  validates :purpose, :nationality, :delivery_method, presence: { message: "is required" }
  validates :pickup_location,
            presence: { message: "is required when delivery method is pickup" },
            if: -> { delivery_method == "pickup" }
  validates :has_driver, inclusion: { in: [true, false], message: "must be selected" }

  validate :planned_return_after_start
  validate :no_overlapping_bookings, if: :dates_changed?
  validate :not_already_booked_by_same_renter, if: :dates_changed?

   enum :status, {
    pending_deposit: 0,         # renter hasn't paid deposit yet
    ready_for_pickup: 1,        # deposit paid, car can be released
    active_rental: 2,           # car is out with renter
    awaiting_final_payment: 3,  # rental ended, final invoice sent
    completed: 4,               # final payment done
    cancelled: 5                # booking cancelled
  }


  # === RENTAL CALCULATION HELPERS ===
  def daily_rate
    return 0.0 unless car&.listing_type == "rent"
    car.price.to_f
  end

  def planned_days
    return 0 unless start_time && planned_return_at
    ((planned_return_at - start_time) / 1.day).ceil
  end

  def total_days_used
    if rental_start_time.present? && rental_end_time.present?
      ((rental_end_time - rental_start_time) / 1.day).ceil
    elsif rental_start_time.present? && planned_return_at.present?
      ((planned_return_at - rental_start_time) / 1.day).ceil
    elsif start_time.present? && planned_return_at.present?
      ((planned_return_at - start_time) / 1.day).ceil
    else
      0
    end
  end

  def overtime_days
    return 0 unless planned_return_at.present?
    compare_time = rental_end_time || Time.current
    days_late = (compare_time.to_date - planned_return_at.to_date).to_i
    days_late.positive? ? days_late : 0
  end

  def commission_rate
    0.10
  end

  def base_rental
    return 0.0 unless car&.listing_type == "rent"
    total_days_used * daily_rate
  end

  def overtime_fee
    return 0.0 unless car&.listing_type == "rent"
    overtime_days * daily_rate
  end

  def platform_commission
    return 0.0 unless car&.listing_type == "rent"
    total_days_used * daily_rate * commission_rate
  end

  def owner_payout
    return 0.0 unless car&.listing_type == "rent"
    (base_rental + overtime_fee) - platform_commission
  end

  def total_paid
    paid_at.present? ? total_price.to_f : 0.0
  end

  def refundable_deposit
    deposit_amount.to_f
  end

  def total_deductions
    deductions = 0.0
    deductions += overtime_fee.to_f
    deductions += platform_commission.to_f
    deductions += car_wash_fee.to_f if respond_to?(:car_wash_fee) && car_wash_fee.present?
    deductions += damage_fee.to_f if respond_to?(:damage_fee) && damage_fee.present?
    deductions += custom_adjustment.to_f if respond_to?(:custom_adjustment) && custom_adjustment.present?
    deductions
  end

  def calculate_total_price
    return 0.0 unless car&.listing_type == "rent"

    total = base_rental + overtime_fee
    total += refundable_deposit if refundable_deposit.positive?
    total += car_wash_fee.to_f if respond_to?(:car_wash_fee) && car_wash_fee.present?
    total += damage_fee.to_f if respond_to?(:damage_fee) && damage_fee.present?
    total += custom_adjustment.to_f if respond_to?(:custom_adjustment) && custom_adjustment.present?
    total
  end

  # === PERMISSIONS ===
  def cancellable_by?(user)
    return false unless user
    if renter == user
      pending? || active?
    elsif car.owner == user
      pending? || active?
    else
      false
    end
  end

  # === REFUND LOGIC ===
  def refundable?
    paid_at.present? && mpesa_receipt_number.present?
  end

  private

  def dates_changed?
    new_record? || will_save_change_to_start_time? || will_save_change_to_planned_return_at?
  end

  def planned_return_after_start
    return if planned_return_at.blank? || start_time.blank?
    if planned_return_at <= start_time
      errors.add(:planned_return_at, "must be after the start date and time")
    end
  end

  def no_overlapping_bookings
    return unless start_time && planned_return_at && car_id
    overlap = Booking.where(car_id: car_id)
                     .where.not(id: id)
                     .where("start_time < ? AND planned_return_at > ?", planned_return_at, start_time)
    if overlap.exists?
      errors.add(:base, "This car is already booked for the selected dates")
    end
  end

  def not_already_booked_by_same_renter
    return unless car_id && user_id && start_time && planned_return_at
    existing = Booking.where(car_id: car_id, user_id: user_id)
                      .where(status: [:pending, :active])
                      .where("start_time < ? AND planned_return_at > ?", planned_return_at, start_time)
    if existing.exists?
      errors.add(:base, "You have already booked this car and it is awaiting owner approval.")
    end
  end
end
