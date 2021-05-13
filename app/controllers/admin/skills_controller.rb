module Admin
  class SkillsController < Admin::BaseController
    before_action :find_skill, only: %i[update destroy]

    def index
      skills = policy_scope(Skill).order(:approved, :title).includes(:skill_type)
      render json: skills,
             each_serializer: SkillSerializer,
             adapter: :json
    end

    def create
      skill = Skill.new(skill_params)
      authorize skill
      if skill.save
        render json: skill,
               adapter: :json
      else
        render json: skill.errors,
               status: :unprocessable_entity,
               adapter: :json
      end
    end

    def update
      authorize @skill
      if @skill.update(skill_params)
        render json: @skill,
               adapter: :json
      else
        render json: @skill.errors,
               status: :unprocessable_entity,
               adapter: :json
      end
    end

    def destroy
      authorize @skill
      @skill.destroy
      head :ok
    end

    private

    def find_skill
      @skill = Skill.find(params[:id])
    end

    def skill_params
      params.require(:skill).permit(
        :title, :difficulty_level_id, :variants, :approved, :skill_type_id
      )
    end
  end
end
