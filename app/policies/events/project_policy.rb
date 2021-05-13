module Events
  class ProjectPolicy < ::EventPolicy
    def create?
      manage_projects?
    end

    def update?
      manage_projects?
    end

    def destroy?
      manage_projects?
    end
  end
end
