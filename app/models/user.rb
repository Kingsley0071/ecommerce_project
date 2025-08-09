class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_associations(auth_object = nil)
    ["orders"] # Add other associations if needed
  end

  def admin?
  self.admin
  end

  def self.ransackable_attributes(auth_object = nil)
  [
    "address",
    "city",
    "created_at",
    "email",
    "id",
    "postal_code",
    "province",
    "remember_created_at",
    "reset_password_sent_at",
    "updated_at",
    "username"
  ]
  end

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true
  validates :city, presence: true
  validates :province, presence: true
  validates :postal_code, presence: true

  # Associations
  has_many :orders, dependent: :destroy
end