class InvitationPolicy < ApplicationPolicy
  def show?
    permission?(:crud, :users)
  end

  def create?
    permission?(:crud, :users)
  end

  def update?
    permission?(:crud, :users)
  end

  def destroy?
    permission?(:crud, :users)
  end
end
