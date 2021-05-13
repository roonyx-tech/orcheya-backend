class NotificationPolicy < ApplicationPolicy
  attr_reader :user, :notification

  def initialize(user, notification)
    @user = user
    @notification = notification
  end

  def read?
    @notification.user_id == @user.id
  end

  class Scope < Scope
    def resolve
      @scope.where(user_id: @user.id)
    end
  end
end
