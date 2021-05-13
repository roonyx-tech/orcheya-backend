module Users
  class SkillUpdatesController < ApplicationController
    before_action :set_user
    before_action :set_user_skill, only: :create

    def create
      skill_update = @user_skill.skills_updates.new(skill_update_level)
      skill_update.approver = current_user
      skill_update.save!
      render json: skill_update.users_skill,
             serializer: UserSkillsUpdatesSerializer,
             adapter: :json
    end

    def bulk_create
      users_skills = []

      params[:skill_updates].each do |skill_update|
        user_skill = UsersSkill.find_or_create_by(user_id: @user.id, skill_id: skill_update[:skill_id])
        @skill_update = user_skill.skills_updates.new(level: skill_update[:level])
        @skill_update.approver = current_user
        @skill_update.save!
        users_skills << @skill_update.users_skill
      end

      SkillUpdateNotifier.notify(:notify_skill_update, users_skills)

      render json: users_skills,
             each_serializer: UserSkillsUpdatesSerializer,
             adapter: :json
    end

    def update
      update = SkillsUpdate.find(params.dig(:id))
      if update.update(params_for_update)
        render json: update.users_skill,
               serializer: UserSkillsUpdatesSerializer,
               apadter: :json
      else
        render json: update.errors,
               status: :unprocessable_entity,
               adapter: :json
      end
    end

    private

    def skill_update_level
      params.require(:skill_update).permit(:level)
    end

    def params_for_update
      params.require(:skill_update).permit(:approved, :approver_id, :comment)
    end

    def set_user_skill
      skill_id = params.dig(:skill_update, :skill_id)
      @user_skill = UsersSkill.find_or_create_by(
        user_id: @user.id, skill_id: skill_id
      )
    end

    def set_user
      @user = User.find_by(id: params[:user_id])
    end
  end
end
