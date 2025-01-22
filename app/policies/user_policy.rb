class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(username: user.username)
      end
    end
  end

  def index? = true

  def show? = self? || admin?

  def create? = admin?

  def new? = admin?

  def update? = self? || admin?

  def edit? = self? || admin?

  def destroy? = self? || admin?

  def edit_password? = self? || admin?

  def update_password? = self? || admin?

  private

  def self?
    user.username == record.username
  end

  def admin?
    user.username == "admin"
  end
end
