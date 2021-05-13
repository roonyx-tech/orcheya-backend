module Users
  class DaysService
    attr_reader :user, :start_date, :finish_date

    def initialize(user, start_date, finish_date)
      @user = user

      finish_date ||= Time.zone.yesterday
      start_date ||= finish_date.beginning_of_month

      @start_date = [start_date.to_date, user.created_at.to_date].max
      @finish_date = [finish_date.to_date, user.deleted_at.try(:to_date)].compact.min
    end

    def vacation_days
      @vacation_days ||= user.vacations.approved.overlap(start_date.beginning_of_day, finish_date.end_of_day).dates
    end

    def holidays
      @holidays ||= Events::Holiday.overlap(start_date.beginning_of_day, finish_date.end_of_day).dates
    end

    def days_off
      @days_off ||= [].concat(holidays, vacation_days).compact.uniq
    end

    def working_days
      @working_days ||= begin
        BusinessTime::Config.holidays = days_off
        (start_date..finish_date).to_a.select(&:workday?)
      end
    end

    def working_days_count
      @working_days_count ||= begin
        BusinessTime::Config.holidays = days_off
        start_date.business_days_until(finish_date.end_of_day)
      end
    end

    class << self
      def workday?(user)
        today = Time.zone.today.to_date
        days_off = new(user, today, today).days_off
        !days_off.include?(today)
      end
    end
  end
end
