class User < ApplicationRecord
  extend PublicFindable["U"]

  devise :database_authenticatable, :rememberable, :argon2

  validates :email, uniqueness: true, allow_nil: true, format: /\A[^@\s]+@[^@\s]+\z/
  validates :username, presence: true, uniqueness: true, length: { in: 2..32 }
  validates :password, presence: true
end
