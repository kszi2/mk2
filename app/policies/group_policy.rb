class GroupPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.joins(:groups_teachers).where("groups_teachers.user_id = :user_id", user_id: user.id)
    end
  end

  def index? = true

  def show? = true

  def create? = true

  def new? = true

  def update? = true

  def edit? = true

  def destroy? = true
end
