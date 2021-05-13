module Admin
  class QuestionsController < ApplicationController
    before_action :set_question, only: %i[update destroy]

    def index
      @questions = policy_scope(Question, policy_scope_class: FaqPolicy::Scope)
      render json: @questions,
             each_serializer: QuestionSerializer,
             adapter: :json
    end

    def create
      question = Question.new(question_params)
      authorize question, policy_class: FaqPolicy

      if question.save
        render json: question, serializer: QuestionSerializer, adapter: :json
      else
        render json: question.errors, status: :unprocessable_entity, adapter: :json
      end
    end

    def update
      authorize @question, policy_class: FaqPolicy

      if @question.update(question_params)
        render json: @question, serializer: QuestionSerializer, adapter: :json
      else
        render json: @question.errors, status: :unprocessable_entity, adapter: :json
      end
    end

    def destroy
      authorize @question, policy_class: FaqPolicy
      @question.destroy
    end

    private

    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :section_id)
    end
  end
end
