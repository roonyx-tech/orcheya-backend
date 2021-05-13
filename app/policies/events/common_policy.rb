module Events
  class CommonPolicy < ::EventPolicy
    def create?
      true
    end

    def update?
      owner? && not_too_old? || manage_all?
    end

    def destroy?
      owner? && not_too_old? || manage_all?
    end
  end
end
