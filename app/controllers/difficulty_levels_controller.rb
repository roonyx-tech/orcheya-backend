class DifficultyLevelsController < ApplicationController
  before_action :find_difficulty, only: %i[update destroy]

  def index
    render json: DifficultyLevel.order(:value),
           each_serializer: DifficultyLevelSerializer,
           adapter: :json
  end

  def create
    difficulty = DifficultyLevel.create(difficulty_params)
    if difficulty.persisted?
      render json: difficulty,
             serializer: DifficultyLevelSerializer,
             adapter: :json
    else
      render json: difficulty.errors,
             status: :unprocessable_entity,
             adapter: :json
    end
  end

  def update
    if @difficulty&.update(difficulty_params)
      render json: @difficulty,
             serializer: DifficultyLevelSerializer,
             adapter: :json
    else
      render json: @difficulty.errors,
             status: :unprocessable_entity,
             adapter: :json
    end
  end

  def destroy
    @difficulty&.destroy
    render json: { status: 204 }
  end

  private

  def find_difficulty
    @difficulty = DifficultyLevel.find_by(id: params[:id])
  end

  def difficulty_params
    params.require(:difficulty_level).permit(:title, :value)
  end
end
