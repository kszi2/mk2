class RatingStylePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index? = true

  def show? = true

  def new? = true

  def create? = true

  def edit? = true

  def update? = true

  def destroy? = true

  def preview? = true
end
