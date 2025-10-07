class Car < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :bookings, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user

  # Ensure image_urls is always an array
  serialize :image_urls, Array

  validates :transmission_type, inclusion: { in: ["Automatic", "Manual"], allow_blank: true }
  validates :fuel_type, inclusion: { in: ["Petrol", "Diesel", "Electric", "Hybrid"], allow_blank: true }
  validates :insurance_status, inclusion: { in: ["Fully insured", "Third-party", "Not insured"], allow_blank: true }
  validates :seats, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  geocoded_by :pickup_address
  after_validation :geocode, if: :will_save_change_to_pickup_address?

  STATUSES = %w[draft published].freeze
  LISTING_TYPES = %w[rent sell].freeze

  validates :status, inclusion: { in: STATUSES }
  validate :must_have_at_least_one_image, if: :published?

  def for_rent?
    listing_type == "rent"
  end

  def for_sale?
    listing_type == "sell"
  end

  def published?
    status == "published"
  end

  private

  def must_have_at_least_one_image
    if image_urls.blank? || image_urls.empty?
      errors.add(:images, "cannot be empty — must have at least one image")
    end
  end
end
