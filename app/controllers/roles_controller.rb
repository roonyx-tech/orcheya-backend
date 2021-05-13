class RolesController < ApplicationController
  before_action :set_role, only: %i[show update destroy]

  def index
    roles = policy_scope(Role).order(:name).includes(:permissions)
    render json: roles
  end

  def show
    authorize @role
    render json: @role
  end

  def create
    @role = Role.new(role_params)
    authorize @role
    if @role.save
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @role
    if @role.update(role_params)
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @role
    new_role = Role.find(params[:new_role]) if params[:new_role].present?

    ActiveRecord::Base.transaction do
      if new_role
        users_with_removing_role.find_each do |user|
          user.roles << new_role
        end
      end
      @role.destroy
    end

    head :ok
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    p = params.require(:role).permit(:name, permissions: [:id])
    p[:permissions] = p[:permissions].present? ? Permission.where(id: p[:permissions].pluck('id')) : []
    p
  end

  def users_with_removing_role
    User.with_deleted.joins(:roles).where(roles: { id: @role })
  end
end
