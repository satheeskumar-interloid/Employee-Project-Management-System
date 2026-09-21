class ProjectPolicy < ApplicationPolicy

  def index?
    user.present?
  end

  def show?
    user.admin? ||
      record.owner == user ||
      record.members.include?(user)
  end

  def create?
    user.admin? || user.employee?
  end

  def update?
    user.admin? || record.owner == user
  end

  def destroy?
    user.admin?
  end

  class Scope < ApplicationPolicy::Scope

    def resolve
      if user.admin?
        scope.all
      else
        scope
          .joins(:project_members)
          .where(project_members: { user_id: user.id })
          .or(
            scope.where(owner_id: user.id)
          )
          .distinct
      end
    end

  end
end