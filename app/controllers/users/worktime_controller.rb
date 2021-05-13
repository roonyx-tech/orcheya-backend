module Users
  class WorktimeController < ApplicationController
    before_action :set_user

    def show
      @worktime = Users::WorktimeService.new(@user)
      render json: {
        working_time: @worktime.working_time,
        worked_out: @worktime.worked_out,
        balance: @worktime.balance,
        timer_on: @user.permissions.exists?(subject: :projects, action: :timer),
        start: @worktime.start_date,
        finish: @worktime.finish_date
      }
    end

    def by_projects
      @worktime = Users::WorktimeService.new(@user, worktime_params)
      render json: {
        working_time_by_projects: @worktime.working_time_by_projects
      }
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def worktime_params
      params.permit(:start_date, :finish_date)
    end
  end
end
