class ProjectsController < ApplicationController
  before_action :set_project, only: :update

  def index
    projects = policy_scope(Project).order(archived: :asc)
    projects = projects.search_by_name(params[:q]) if params[:q].present?
    render json: projects,
           each_serializer: ProjectSerializer,
           adapter: :json
  end

  def create
    @project = Project.new(project_params)
    @project.platform ||= :inner
    authorize @project
    if @project.save
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @project
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.permit(:title, :paid, :archived, :manager_id, :platform)
  end
end
