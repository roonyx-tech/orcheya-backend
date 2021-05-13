class WorklogsController < ApplicationController
  def index
    render json: WorklogService.call(params)
  end
end
