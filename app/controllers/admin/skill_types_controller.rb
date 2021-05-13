module Admin
  class SkillTypesController < Admin::BaseController
    before_action :set_skill_type, only: %i[show update destroy]

    def index
      skill_types = policy_scope(SkillType).order(:title)
      render json: skill_types
    end

    def show
      authorize @inv_type
      render json: @inv_type
    end

    def create
      @inv_type = SkillType.create(skill_type_params)
      authorize @inv_type
      if @inv_type.persisted?
        render json: @inv_type
      else
        render json: @inv_type.errors,
               status: :unprocessable_entity,
               adapter: :json
      end
    end

    def update
      authorize @inv_type
      if @inv_type.update(skill_type_params)
        render json: @inv_type
      else
        render json: @inv_type.errors,
               status: :unprocessable_entity,
               adapter: :json
      end
    end

    def destroy
      authorize @inv_type
      new_inv_type = SkillType.find params[:new_skill_type]

      ActiveRecord::Base.transaction do
        @inv_type.skills.find_each do |event|
          event.update!(skill_type: new_inv_type)
        end
        @inv_type.destroy
      end

      head :ok
    end

    private

    def set_skill_type
      @inv_type = SkillType.find(params[:id])
    end

    def skill_type_params
      params[:skill_type].permit(:title)
    end
  end
end
