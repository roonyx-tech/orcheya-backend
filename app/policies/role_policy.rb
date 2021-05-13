class RolePolicy < ApplicationPolicy
  def create?
    permission?('roles', 'admin')
  end

  def show?
    true
  end

  def update?
    permission?('roles', 'admin')
  end

  def destroy?
    permission?('roles', 'admin')
  end
end
