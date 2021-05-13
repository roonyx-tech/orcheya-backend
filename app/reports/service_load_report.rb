# rubocop:disable ClassLength
class ServiceLoadReport
  attr_reader :start, :finish, :range, :unit

  UNIT_FORMATS = {
    day: '%d-%m-%Y',
    week: '%Y, %W week',
    month: '%Y, %b',
    year: '%Y'
  }.freeze

  def initialize(start, finish, unit)
    @start = start
    @finish = finish
    @range = start..finish
    @unit = unit.to_sym
  end

  def report
    {
      dash: dash,
      dates: dates_for_graph,
      load_table: load_table,
      users_table: users_table,
      projects_table: projects_table
    }
  end

  class << self
    def report(start, finish, unit)
      new(start, finish, unit).report
    end
  end

  private

  def dates
    @dates ||= range.group_by { |date| date.strftime(UNIT_FORMATS[unit]) }
  end

  def users
    @users ||= Permission.users_by('projects:timer').for_report(start, finish)
  end

  def projects
    @projects ||= begin
      ids = Worklog.where(date: @range).pluck(:project_id).uniq
      Project.active.where(id: ids)
    end
  end

  def user_working_time
    @user_working_time ||= users.each_with_object({}) do |user, result|
      result[user.id] = Users::WorktimeService.new(user, start_date: start, finish_date: finish).working_time
    end
  end

  def user_worked_time
    @user_worked_time ||= dates.map do |_, x|
      users.inject(0) do |sum, user|
        sum + Users::WorktimeService.new(user, start_date: x.first, finish_date: x.last).working_time
      end
    end
  end

  def dash
    {
      workdays: workdays,
      developers: users.count, # TODO: Rename developers -> user
      other: 0, # TODO: Remove this
      hours: hours,
      worked_hours: total_worked_hours,
      paid_hours: total_paid_hours,
      total_paid: hours.positive? ? total_paid_hours * 100 / hours : 0,
      active_projects: projects.count,
      paid_projects: projects.paid.count
    }
  end

  def workdays
    @workdays ||= begin
      BusinessTime::Config.holidays = Events::Holiday.overlap(start.beginning_of_day, finish.end_of_day)
      start.business_days_until(finish.end_of_day)
    end
  end

  def hours
    users.inject(0) do |sum, user|
      sum + user_working_time[user.id]
    end
  end

  def total_worked_hours
    worked_time.select { |k, _| users.ids.include?(k) }.values.sum
  end

  def total_paid_hours
    paid_hours.select { |k, _| users.ids.include?(k) }.values.sum
  end

  def users_table
    rows = users.map do |user|
      paid = paid_hours[user.id] || 0
      user_time = user_working_time[user.id]
      {
        name: user.name,
        surname: user.surname,
        worked: worked_time[user.id] || 0,
        paid: paid,
        time: user_time,
        load: user_time.positive? ? paid * 100 / user_time : 0
      }
    end
    rows.sort_by { |a| -1 * a[:load] }
  end

  def worked_time
    @worked_time ||= users.joins(:worklogs)
                          .where(worklogs: { date: @range })
                          .group(:id)
                          .sum('worklogs.length')
  end

  def paid_hours
    @paid_hours ||= users.joins(worklogs: :project)
                         .where(
                           id: users.ids,
                           projects: { paid: true },
                           worklogs: { date: @range }
                         )
                         .group(:id)
                         .sum('worklogs.length')
  end

  def projects_table
    @projects_table ||= projects.joins(:worklogs)
                                .where(worklogs: { date: @range })
                                .group(:id)
                                .order('time DESC')
                                .select(:name, :id, :project_id, :paid, 'SUM(worklogs.length) as time')
                                .map(&:attributes)
  end

  def load_table
    real_times = calc_hours_for(paid)
    dates.each_with_index.map do |_, index|
      {
        percent: user_worked_time[index].positive? ? real_times[index] * 100 / user_worked_time[index] : 0,
        plan: user_worked_time[index],
        real: real_times[index]
      }
    end
  end

  def calc_hours_for(data)
    data = data.group_by { |x| x.date.strftime(UNIT_FORMATS[unit]) }
               .each_with_object({}) { |(k, v), o| o[k] = v.sum(&:sum) }
    add_zero_values(data)
  end

  def add_zero_values(data)
    @dates.map { |x, _| data[x] || 0 }
  end

  def dates_for_graph
    dates.map do |k, v|
      case unit
      when :week
        f = v.first.strftime('%d %b')
        l = v.last.strftime('%d %b')
        "#{f} - #{l}"
      when :month
        Date.parse(k).strftime('%b')
      end
    end
  end

  def paid
    ids = users.pluck(:id)
    Worklog
      .with_deleted
      .joins('INNER JOIN "projects" ON "projects"."id" = "worklogs"."project_id" ' \
               'INNER JOIN "users" ON "users"."id" = "worklogs"."user_id"')
      .where(
        projects: { paid: true },
        date: @range,
        users: { id: ids }
      )
      .group('date')
      .select('date, sum(length)')
      .order(:date)
  end
end
# rubocop:enable ClassLength
