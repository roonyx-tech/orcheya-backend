module Admin
  class AchievementsController < Admin::BaseController
    before_action :set_achievement, only: %i[show update destroy]

    def index
      achievements = policy_scope(Achievement).includes(:roles, :users, :levels)
      render json: achievements,
             each_serializer: Admin::AchievementSerializer,
             adapter: :json
    end

    def show
      authorize @achievement
      render json: @achievement, serializer: Admin::AchievementSerializer, adapter: :json
    end

    def create
      achievement = Achievement.new(achievement_params)
      authorize achievement
      if achievement.save
        render json: achievement, serializer: Admin::AchievementSerializer, adapter: :json
      else
        render json: achievement.errors, status: :unprocessable_entity, adapter: :json
      end
    end

    def update
      authorize @achievement
      if @achievement.update(achievement_params)
        render json: @achievement, serializer: Admin::AchievementSerializer, adapter: :json
      else
        render json: @achievement.errors, status: :unprocessable_entity, adapter: :json
      end
    end

    def destroy
      authorize @achievement
      @achievement.destroy
    end

    def counters
      authorize current_user, :counters?, policy_class: AchievementPolicy
      render json: UsersAchievement::COUNTERS
    end

    private

    def achievement_params
      params[:kind] == 'auto' ? achievement_auto_params : achievement_manual_params
    end

    def achievement_auto_params
      levels_attrs = %i[id name from to color number _destroy second_color third_color]
      params.permit(:title, :kind, :image, :endpoint, role_ids: [],
                                                      levels_attributes: levels_attrs)
    end

    def achievement_manual_params
      params.permit(:title, :kind, :image, :endpoint, user_ids: [])
    end

    def set_achievement
      @achievement = Achievement.find(params[:id])
    end
  end
end
