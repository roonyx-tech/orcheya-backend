class UpdatesController < ApplicationController
  before_action :set_update, only: %i[show update]

  def index
    updates = Update.filter(filtering_params)
                    .includes(:user, :projects)
                    .order(date: :desc)
                    .distinct
    updates = updates.page(params[:page]).per(params[:limit])
    render json: updates,
           meta: pagination_meta(updates),
           each_serializer: UpdateSerializer,
           adapter: :json
  end

  def show
    render json: @update, serializer: UpdateSerializer, adapter: :json
  end

  def create
    update = UpdateService.create(current_user, create_params)

    if update.persisted?
      render json: update,
             serializer: UpdateSerializer,
             adapter: :json
    else
      render json: update.errors.messages,
             status: :unprocessable_entity,
             adapter: :json
    end
  end

  def update
    update = UpdateService.update(current_user, @update, update_params)

    if update.valid?
      render json: update,
             serializer: UpdateSerializer,
             adapter: :json
    else
      render json: update.errors.messages,
             status: :unprocessable_entity,
             adapter: :json
    end
  end

  private

  def set_update
    @update = Update.find(params[:id])
  end

  def create_params
    params.permit(:made, :planning, :issues, :date)
  end

  def update_params
    params.permit(:made, :planning, :issues)
  end

  def filtering_params
    params.slice(:query,
                 :user_ids['user_ids'],
                 :project_ids['project_ids'],
                 :start_date, :end_date)
  end
end
