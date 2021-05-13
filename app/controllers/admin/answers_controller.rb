module Admin
  class AnswersController < ApplicationController
    before_action :set_answer, only: %i[update destroy]

    def index
      @answers = policy_scope(Answer, policy_scope_class: FaqPolicy::Scope)
      render json: @answers,
             each_serializer: AnswerSerializer,
             adapter: :json
    end

    def create
      answer = Answer.new(answer_params)
      authorize answer, policy_class: FaqPolicy

      if answer.save
        render json: answer, serializer: AnswerSerializer, adapter: :json
      else
        render json: answer.errors, status: :unprocessable_entity, adapter: :json
      end
    end

    def update
      authorize @answer, policy_class: FaqPolicy

      if @answer.update(answer_params)
        render json: @answer, serializer: AnswerSerializer, adapter: :json
      else
        render json: @answer.errors, status: :unprocessable_entity, adapter: :json
      end
    end

    def destroy
      authorize @answer, policy_class: FaqPolicy
      @answer.destroy
    end

    private

    def set_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:content, :question_id)
    end
  end
end
