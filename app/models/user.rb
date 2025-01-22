class User < ApplicationRecord
  extend PublicFindable["U"]

  devise :database_authenticatable, :rememberable, :argon2

  validates :email, uniqueness: true, allow_nil: true, format: /\A[^@\s]+@[^@\s]+\z/
  validates :username, presence: true, uniqueness: true, length: { in: 2..32 }
  validates :password, presence: true, on: :create
  validate :confirmation_matches

  before_validation :remove_blank_email

  # TODO: a proper admin system
  def admin? = username == "admin"

  private

  def confirmation_matches
    return if password == password_confirmation
    errors.add(:password_confirmation, "doesn't match Password")
  end

  def remove_blank_email
    self.email = nil if email.blank?
  end
end
