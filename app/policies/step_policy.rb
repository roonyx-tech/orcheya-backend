class StepPolicy < ApplicationPolicy
  def create?
    permission?(:super_admin, :admin)
  end

  def integrations?
    permission?(:super_admin, :admin)
  end

  def update?
    permission?(:super_admin, :admin)
  end

  def destroy?
    permission?(:super_admin, :admin)
  end
end
