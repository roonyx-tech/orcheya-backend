module Events
  class HolidayPolicy < ::EventPolicy
    def create?
      manage_holidays?
    end

    def update?
      manage_holidays?
    end

    def destroy?
      manage_holidays?
    end
  end
end
