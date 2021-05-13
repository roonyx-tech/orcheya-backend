class UserPolicy < ApplicationPolicy
  def busy?
    permission? :busy, :users
  end

  def invite?
    permission?(:crud, :users)
  end

  def update?
    permission?(:crud, :users)
  end

  def destroy?
    permission?(:crud, :users)
  end

  def login_as?
    permission?(:super_admin, :admin)
  end

  def english_level?
    permission?(:english_level, :admin)
  end

  def sidekiq_management?
    permission?(:super_admin, :admin)
  end
end
