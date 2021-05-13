module Reports
  class ServiceLoadController < ApplicationController
    def index
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      step = params[:step]

      render json: ServiceLoadReport.report(start_date, end_date, step)
    end
  end
end
