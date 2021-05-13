class PlanPolicy < ApplicationPolicy
  def people?
    permission?(:planning, :projects)
  end

  def managers?
    permission?(:planning, :projects)
  end

  def projects?
    permission?(:planning, :projects)
  end
end
