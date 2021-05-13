class ProfilesController < ApplicationController
  before_action :set_user

  def show
    render json: @user,
           serializer: ProfileSerializer,
           adapter: :json,
           include: '*.*'
  end

  def edit
    render json: Timing.order(:flexible, :start, :end),
           each_serializer: TimingIndexSerializer,
           adapter: :json
  end

  def update
    @user.registration_finished = true
    if @user.update(user_params)
      render json: @user, serializer: ProfileSerializer, adapter: :json
    else
      render json: @user.errors, status: :unprocessable_entity, adapter: :json
    end
  end

  def update_avatar
    @user.avatar = params[:avatar]
    @user.save(validate: false)
    render json: @user, serializer: ProfileSerializer, adapter: :json
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params_to_permit = %i[email name surname name_cyrillic surname_cyrillic birthday employment_at
                          sex timing_id skype phone role notify_update discord_notify_update about discord_name]
    params.require(:user)
          .permit(params_to_permit)
  end
end
