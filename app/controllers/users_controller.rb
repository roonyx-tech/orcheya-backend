class UsersController < ApplicationController
  include UserModule
  before_action :set_user, except: %i[index search]
  before_action :find_skills, only: [:search]
  def index
    search = params[:search]

    users = User.where(invitation_token: nil)
    users = users.search_by_name(search) if search
    users = users.joins(:roles).where(roles: { id: role_id }) if role_id.present?
    users = users.includes(:timing, :roles, users_skills: :skill)
                 .order('lower(users.name), lower(users.surname)')
                 .page(params[:page])
                 .per(params[:limit])

    render json: users,
           meta: pagination_meta(users),
           each_serializer: UserIndexSerializer,
           include: %w[users_skills.skill timing roles],
           adapter: :json
  end

  def show
    render json: @user, include: '*.*', adapter: :json
  end

  def update
    if @user.update(user_params)
      render json: @user, serializer: UserSerializer, adapter: :json
    else
      render json: @user.errors, status: :unprocessable_entity, adapter: :json
    end
  end

  def timegraph
    render json: generate_timegraph
  end

  def stats
    today = Time.zone.now.to_date

    render json: {
      week: week_stats(today),
      month: month_stats(today),
      prev_month: month_stats(today.prev_month)
    }
  end

  def day_info
    date = params[:date].to_date || Date.current

    render json: {
      worked: Users::TasksService.by_date(@user, date),
      current_update: @user.updates.at(date).first,
      prev_update: @user.updates.to(date - 1.day).order(date: :desc).first
    }
  end

  def search
    user_skills = UsersSkill.has_level.where(skill_id: @skills.uniq).pluck(:user_id).uniq
    users = User.where(id: user_skills).includes(:users_skills, :roles)
    render json: users, each_serializer: UserWithSkillSerializer, adapter: :json
  end

  private

  def user_params
    params.require(:user).permit(:english_level) if authorize current_user, :english_level?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def role_id
    params.permit(:role_is).dig('role_is')
  end

  def source
    @source ||= params[:source] || Worklog.sources.values
  end

  def find_skills
    @skills = search_skills
  end
end
