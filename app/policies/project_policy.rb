class ProjectPolicy < ApplicationPolicy
  def create?
    permission?(:planning, :projects)
  end

  def update?
    permission?(:planning, :projects)
  end
end
