class SkillTypesController < ApplicationController
  def index
    render json: SkillType.all.order(:title)
  end
end
