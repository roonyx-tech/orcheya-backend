class TrackEventsController < ApplicationController
  def create
    TrackEvent.track(current_user, event_param)
    head :ok
  end

  private

  def event_param
    params.require(:e)
  end
end
