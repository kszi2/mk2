class User < ApplicationRecord
  extend PublicFindable["U"]

  devise :database_authenticatable, :rememberable, :argon2

  validates :email, uniqueness: true, allow_nil: true, format: /\A[^@\s]+@[^@\s]+\.[^@.\s]+\z/
  validates :username, presence: true, uniqueness: true, length: { in: 2..32 }
  validates :password, presence: true, on: :create
  validate :confirmation_matches

  has_and_belongs_to_many :taught_groups, class_name: Group.name, join_table: "groups_teachers"
  before_validation :remove_blank_email

  def known_students
    return Student if admin?

    Student.joins(groups: [ :teachers ]).where(users: { id: self.id })
           .union(Student.joins(groups: [ :course ]).where(course: { privacy_preserving: false }))
  end

  # TODO: a proper admin system
  def admin? = username == "admin"

  def render_as = username

private

  def confirmation_matches
    return if password == password_confirmation
    errors.add(:password_confirmation, "doesn't match Password")
  end

  def remove_blank_email
    self.email = nil if email.blank?
  end
end
