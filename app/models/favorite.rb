class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :car_id, uniqueness: { scope: :owner_id }
end
