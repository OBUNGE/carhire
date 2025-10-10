class CarImage < ApplicationRecord
  belongs_to :car

  validates :image_url, presence: true
  validates :cover, inclusion: { in: [true, false] }

  # Optional: normalize to ensure only one cover per car
  before_save :ensure_single_cover

  private

  def ensure_single_cover
    return unless cover?

    # Unset cover on other images of the same car
    car.car_images.where.not(id: id).update_all(cover: false)
  end
end
