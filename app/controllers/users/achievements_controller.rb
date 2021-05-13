module Users
  class AchievementsController < ApplicationController
    before_action :set_user
    before_action :set_users_achievement, only: :set_favorite

    def index
      render json: @user.users_achievements,
             each_serializer: UsersAchievementSerializer,
             adapter: :json
    end

    def set_favorite
      @users_achievement.clean_favorites
      @users_achievement.update(favorite: true)
      render json: @users_achievement, serializer: UsersAchievementSerializer, adapter: :json
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_users_achievement
      @users_achievement = UsersAchievement.find(params[:id])
    end
  end
end
