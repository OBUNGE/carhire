class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Cars this user owns
  has_many :cars, foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy

  # Bookings this user made as a renter
  has_many :bookings_as_renter, class_name: "Booking", foreign_key: :renter_id

  # Bookings on cars this user owns (owner perspective)
  has_many :bookings_as_owner, through: :cars, source: :bookings

  has_many :bookings
  has_many :owned_bookings, through: :cars, source: :bookings
  has_many :purchases, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_cars, through: :favorites, source: :car

  ROLES = %w[owner user admin]
  validates :role, inclusion: { in: ROLES }

  before_save :normalize_names
  after_initialize :set_default_role, if: :new_record?

  # === Normalization ===
  def normalize_names
    self.first_name = first_name&.strip&.downcase&.capitalize
    self.last_name  = last_name&.strip&.downcase&.capitalize
  end

  def set_default_role
    self.role ||= "user"
  end

  # === Name helpers ===
  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def first_name_only
    first_name.presence || email
  end

  # === Role helpers ===
  def owner? = role == "owner"
  def user?  = role == "user"
  def admin?
    self[:admin] || role == "admin"
  end

  # === Omniauth ===
  def self.from_omniauth(access_token, role_param = nil)
    data = access_token.info
    user = User.find_by(email: data['email'])

    unless user
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0, 20],
        first_name: data['first_name'],
        last_name: data['last_name'],
        role: role_param.presence || "user"
      )
    end
    user
  end
end
