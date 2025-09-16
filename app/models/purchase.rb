class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :car

  enum :status, { pending: 0, approved: 1, rejected: 2, cancelled: 3 }

  validates :status, presence: true
  validates :message, length: { maximum: 1000 }, allow_blank: true

  # Optional helper for showing seller info in the dashboard
  def contact_info
    if car&.user
      [car.user.email, car.user.try(:phone_number)].compact.join(" | ")
    else
      "N/A"
    end
  end
end
