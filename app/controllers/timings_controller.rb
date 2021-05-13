class TimingsController < ApplicationController
  def index
    render json: Timing.order(:end),
           each_serializer: TimingIndexSerializer,
           adapter: :json
  end
end
