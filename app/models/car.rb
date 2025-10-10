class Car < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  has_many :bookings, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user

  # ✅ Supabase image URL replaces ActiveStorage
  # Removed: has_many_attached :images

  # -------------------
  # Validations
  # -------------------
  validates :make, :model, :price, :pickup_address, presence: true
  validates :transmission_type, inclusion: { in: ["Automatic", "Manual"], allow_blank: true }
  validates :fuel_type, inclusion: { in: ["Petrol", "Diesel", "Electric", "Hybrid"], allow_blank: true }
  validates :insurance_status, inclusion: { in: ["Fully insured", "Third-party", "Not insured"], allow_blank: true }
  validates :seats, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :image_url, presence: true, if: :published?

  STATUSES = %w[draft published].freeze
  LISTING_TYPES = %w[rent sell].freeze

  validates :status, inclusion: { in: STATUSES }

  # -------------------
  # Geocoding
  # -------------------
  geocoded_by :pickup_address
  after_validation :geocode, if: :will_save_change_to_pickup_address?

  # -------------------
  # Scopes
  # -------------------
  scope :available_between, ->(start_time, end_time) {
    where.not(
      id: Booking.where("start_time < ? AND planned_return_at > ?", end_time, start_time).pluck(:car_id)
    )
  }

  scope :by_destination, ->(destination) {
    where("pickup_address ILIKE ?", "%#{destination}%") if destination.present?
  }

  # -------------------
  # Helpers
  # -------------------
  def for_rent?
    listing_type == "rent"
  end

  def for_sale?
    listing_type == "sell"
  end

  def published?
    status == "published"
  end

  def available?(start_time, end_time)
    bookings.where("start_time < ? AND planned_return_at > ?", end_time, start_time).none?
  end
end
