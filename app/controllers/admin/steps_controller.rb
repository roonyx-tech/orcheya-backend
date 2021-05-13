module Admin
  class StepsController < ApplicationController
    before_action :set_step, only: %i[update destroy]

    def index
      @steps = policy_scope(Step)
      filter_by_params
      render json: @steps,
             each_serializer: Admin::StepSerializer,
             format: :json
    end

    def integrations
      authorize current_user, policy_class: StepPolicy
      render json: Step::INTEGRATION_TYPES
    end

    def create
      step = Step.new(step_params)
      authorize step
      if step.save
        render json: step,
               adapter: :json
      else
        render json: step.errors,
               status: :unprocessable_entity,
               adapter: :json
      end
    end

    def update
      authorize @step
      if @step.update(step_params)
        render json: @step,
               adapter: :json
      else
        render json: @step.errors,
               status: :unprocessable_entity,
               adapter: :json
      end
    end

    def destroy
      authorize @step
      @step.destroy
    end

    private

    def set_step
      @step = Step.find(params[:id])
    end

    def step_params
      params.require(:step).permit(:name, :link, :kind, :default, onboarding_ids: [], role_ids: [])
    end

    def filter_by_params
      @steps = @steps.joins(:roles).where(roles: { id: params[:role_id] }) if params[:role_id].present?
      @steps = @steps.where(default: true) if params[:default].present? && params[:default] == 'true'
      @steps = @steps.where(kind: params[:kind]) if params[:kind].present? && Step::KINDS.include?(params[:kind])
    end
  end
end
