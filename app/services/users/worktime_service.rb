module Users
  class WorktimeService
    attr_reader :user, :days
    delegate :start_date,
             :finish_date,
             :working_days,
             :working_days_count,
             :days_off,
             :holidays,
             :vacation_days,
             to: :days

    def initialize(user, options = {})
      @user = user
      @days = Users::DaysService.new(user, options[:start_date], options[:finish_date])
    end

    def working_time
      ActiveSupport::Duration.build(working_days_count * user.working_hours * 3600 / 5)
    end

    def working_time_by_dates
      BusinessTime::Config.holidays = days_off
      working_days.map do |date|
        {
          date: date,
          time: ActiveSupport::Duration.build(days_off.include?(date) ? 0 : user.working_hours * 3600 / 5)
        }
      end
    end

    def working_time_by_projects
      data = {}
      worklogs = @user.worklogs.where('date BETWEEN ? AND ?', @days.start_date, @days.finish_date)
      all_time = worklogs.sum(:length)
      projects = worklogs.map(&:project).uniq

      projects.each do |project|
        data[project.name.to_s] = worklogs.where(project: project).sum(:length).to_f / all_time * 100
      end
      data
    end

    def worked_out
      ActiveSupport::Duration.build(user.worklogs.where(date: start_date..finish_date).sum(:length))
    end

    def balance
      worked_out - working_time
    end
  end
end
