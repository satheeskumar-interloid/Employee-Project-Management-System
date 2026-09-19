class ProjectPolicy < ApplicationPolicy


  def index?
    true 
  end

  def show?
    user.admin? || record.user_id == user.id
  end

  def create?
    user.admin? || user.employee?
  end

  def update?
    user.admin? || record.user_id == user.id
  end

  def destroy?
    user.admin?
  end



  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
