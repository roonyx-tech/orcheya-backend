class SkillsController < ApplicationController
  include UserModule

  before_action :find_skills, only: [:search]
  def index
    render json: Skill.approved_skills.order(:title),
           each_serializer: SkillSerializer,
           adapter: :json
  end

  def create
    skill = Skill.create(skill_params)
    if skill.persisted?
      render json: skill,
             serializer: SkillSerializer,
             adapter: :json
    else
      render json: skill.errors,
             status: :unprocessable_entity,
             adapter: :json
    end
  end

  def search
    render json: Skill.where(id: @skills),
           each_serializer: SkillSerializer,
           adapter: :json
  end

  private

  def skill_params
    params.require(:skill).permit(:title, :difficulty_level_id, :variants)
  end

  def find_skills
    @skills = search_skills
  end
end
