class DashboardsController < ApplicationController
  include UserModule

  def index
    users = User.where(invitation_token: nil)
    users = users.sort { |a, b| Users::WorktimeService.new(b).balance <=> Users::WorktimeService.new(a).balance }

    render json: users,
           each_serializer: DashboardIndexSerializer,
           include: %w[roles],
           adapter: :json
  end
end
