class AchievementPolicy < ApplicationPolicy
  def show?
    permission?(:achievements, :admin)
  end

  def create?
    permission?(:achievements, :admin)
  end

  def update?
    permission?(:achievements, :admin)
  end

  def destroy?
    permission?(:achievements, :admin)
  end

  def counters?
    permission?(:achievements, :admin)
  end
end
