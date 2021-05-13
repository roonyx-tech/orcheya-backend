class NotificationsController < ApplicationController
  before_action :set_notification, only: :read

  rescue_from Pundit::NotAuthorizedError do
    head :forbidden
  end

  def index
    render json: policy_scope(Notification),
           each_serializer: NotificationSerializer,
           adapter: :json
  end

  def read
    @notification.update! readed_at: Time.current
  end

  def read_all
    date = Time.current

    current_user.notifications.find_each do |notification|
      notification.update! readed_at: date
    end
  end

  private

  def set_notification
    notification = Notification.find(params[:id])
    @notification = notification if authorize notification
  end
end
