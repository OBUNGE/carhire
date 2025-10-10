class Car < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  has_many :bookings, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user

  # -------------------
  # Images (Supabase-backed)
  # -------------------
  has_many :car_images, dependent: :destroy
  has_one :cover_image, -> { where(cover: true) }, class_name: "CarImage"

  accepts_nested_attributes_for :car_images, allow_destroy: true

  # -------------------
  # Validations
  # -------------------
  STATUSES = %w[draft published].freeze
  LISTING_TYPES = %w[rent sell].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :listing_type, inclusion: { in: LISTING_TYPES }

  # Require at least one image if published
  validate :must_have_image_if_published

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
