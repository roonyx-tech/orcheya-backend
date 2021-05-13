module Users
  class UpdateReportsController < ApplicationController
    before_action :set_user
    before_action :date_range

    def index
      reported_users = User.joins(:updates).where(updates: { date: @range })
                           .group(:id)
                           .having('count(updates.id) >= ?', @filtered_range.count)

      not_reported_users = {}
      all_users = Array.wrap(User.all)

      @filtered_range.each do |day|
        diff = all_users - Array.wrap(reported_users)
        not_reported_users[day] = diff if diff.any?
      end

      users = {
        reported: reported_users,
        not_reported: not_reported_users
      }

      render json: users,
             each_serializer: UserSerializer,
             adapter: :json
    end

    def date_range
      @range = Date.parse(params[:start_date])..Date.parse(params[:end_date])
      @filtered_range = @range.reject { |d| d.wday.zero? || d.wday == 6 }
    end

    def set_user
      @user = User.find_by(id: params[:user_id])
    end
  end
end
