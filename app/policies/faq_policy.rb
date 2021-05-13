class FaqPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all if permission?(:faq, :admin)
    end
  end

  def create?
    permission?(:faq, :admin)
  end

  def update?
    permission?(:faq, :admin)
  end

  def destroy?
    permission?(:faq, :admin)
  end
end
