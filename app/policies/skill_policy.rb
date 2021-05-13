class SkillPolicy < ApplicationPolicy
  def create?
    permission?('skills', 'admin')
  end

  def update?
    permission?('skills', 'admin')
  end

  def destroy?
    permission?('skills', 'admin')
  end
end
