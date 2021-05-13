class TimingPolicy < ApplicationPolicy
  def show?
    permission?(:super_admin, :admin)
  end

  def create?
    permission?(:super_admin, :admin)
  end

  def update?
    permission?(:super_admin, :admin)
  end

  def destroy?
    permission?(:super_admin, :admin)
  end
end
