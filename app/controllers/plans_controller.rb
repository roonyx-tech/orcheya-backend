class PlansController < ApplicationController
  def managers
    authorize :plan
    permission = Permission.find_by!(subject: :projects, action: :planning)
    users = policy_scope(permission.users).order(:name, :surname)
    render json: users, each_serializer: UserShortInfoSerializer
  end

  def people
    authorize :plan
    permission = Permission.find_by!(subject: :projects, action: :participant)
    users = policy_scope(permission.users.invitation_accepted).order(:name, :surname)
    render json: users, each_serializer: PlanResourceSerializer
  end

  def projects
    authorize :plan
    projects = policy_scope(Project.active).where(platform: %w[inner])
                                           .includes(:manager, :users)
                                           .order(paid: :desc, title: :desc)
    render json: projects, each_serializer: PlanResourceSerializer
  end
end
