module Events
  class VacationPolicy < ::EventPolicy
    def create?
      owner? || manage_all?
    end

    def update?
      owner? && not_too_old? && record.draft? || manage_all?
    end

    def destroy?
      owner? && not_too_old? || manage_all?
    end

    def approve?
      permission? :vacation, :calendar
    end

    def disapprove?
      permission? :vacation, :calendar
    end
  end
end
