module Reports
  class TimesheetController < ApplicationController
    def index
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      users_ids = parse_ids params[:users_ids]
      roles_ids = parse_ids params[:roles_ids]

      render json: TimesheetReport.report(
        start_date,
        end_date,
        users_ids,
        roles_ids
      )
    end

    private

    def parse_ids(data)
      data ? data.split(',') : nil
    end
  end
end
