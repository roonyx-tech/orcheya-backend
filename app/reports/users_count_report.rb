class UsersCountReport
  def self.report(year)
    new(year).count_users
  end

  def self.average_report(start_year, end_year)
    new(start_year, end_year).average_count
  end

  def initialize(start_year, end_year = start_year)
    @start_date = Date.new(start_year.to_i, 1, 1)
    @end_date = Date.new(end_year.to_i, 12, 31)
    @end_date = (Time.zone.today - 28.days).end_of_month if @end_date > Time.zone.today
  end

  def average_count
    average_report = []
    report = count_users
    years = report.map { |el| el[:year] }.uniq
    years.each do |year|
      year_report = report.select { |el| el[:year] == year }
      sum = 0
      year_report.each { |el| sum += el[:users] }
      average_report << { year: year, users: (sum.to_f / year_report.count).round }
    end

    average_report
  end

  def count_users
    report = []
    dates = []
    date = @start_date.end_of_month

    while date <= @end_date.end_of_month
      dates << date.end_of_month
      date += 1.month
    end

    dates.each do |d|
      users = User.with_deleted
                  .where('(employment_at < ? OR (invitation_accepted_at < ? AND employment_at IS NULL))
                          AND (deleted_at > ? OR deleted_at IS NULL)', d, d, d)

      report << { year: d.strftime('%Y'), month: d.strftime('%B'), users: users.count }
    end

    report
  end
end
