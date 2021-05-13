module Users
  class SkillsController < ApplicationController
    before_action :set_user

    def index
      render json: @user.users_skills,
             each_serializer: UserSkillsUpdatesSerializer,
             adapter: :json
    end

    def destroy
      user_skill = UsersSkill.find(params[:id])
      user_skill.destroy
      render json: { status: 204 }
    end

    private

    def set_user
      @user = User.find_by(id: params[:user_id])
    end
  end
end
