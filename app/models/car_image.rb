class CarImage < ApplicationRecord
  belongs_to :car

  # Ensure images are ordered within each car
  acts_as_list scope: :car
  default_scope { order(:position) }

  # Validations
  validates :image_url, presence: true
  validates :cover, inclusion: { in: [true, false] }

  # Normalize to ensure only one cover per car
  before_save :ensure_single_cover
  after_destroy :assign_new_cover, if: :cover?

  private

  def ensure_single_cover
    return unless cover?
    car.car_images.where.not(id: id).update_all(cover: false)
  end

  def assign_new_cover
    car.car_images.first&.update(cover: true)
  end
end
