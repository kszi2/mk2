class StudentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.admin?
        scope.all
      else
        scope.joins(groups: [ :teachers ])
             .where(users: { id: user.id })
             .union(scope.joins(groups: [ :course ])
                         .where(course: { privacy_preserving: false }))
      end
    end
  end

  def index? = true

  def show?
    return true if admin?

    Student.joins(groups: [ :teachers ])
           .where(users: { id: user.id })
           .where(students: { id: record.id })
           .union(
             Student.joins(groups: [ :course ])
                    .where(course: { privacy_preserving: false })
                    .where(students: { id: record.id })
           )
           .exists?
  end

  def new? = admin?

  def edit? = admin?

  def import? = admin?

  def bulk_create? = admin?

  def create? = admin?

  def update? = admin?

  def destroy? = admin?

private

  delegate :admin?, to: :user
end
