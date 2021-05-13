class TimesheetReport
  def self.report(start_date, end_date, users_ids, roles_ids)
    new(start_date, end_date, users_ids, roles_ids).report
  end

  def self.week_report(start_date, end_date)
    new(start_date, end_date).week_report
  end

  def initialize(start_date, end_date, users_ids = nil, roles_ids = nil)
    @start = start_date
    @end = end_date
    @users_ids = users_ids || User.for_report(@start, @end).ids
    @roles_ids = roles_ids || Role.ids
  end

  def report
    users.map do |user|
      attrs = user.slice(%i[id name surname])
      attrs[:all_worklogs] = all_worklogs(user)
      attrs[:paid_worklogs] = paid_worklogs(user)
      attrs[:plan] = plan(user)
      attrs
    end
  end

  def week_report
    min_worked_users = []
    min_not_enough = []
    max_worked_users = []

    users.each do |user|
      hours = worked_plan(user).to_i / 3600
      if hours < user.working_hours
        min_not_enough << user
        min_worked_users << user if hours >= 35
      elsif hours >= 35
        min_worked_users << user
        max_worked_users << user if hours >= 40
      end
    end

    {
      min_worked_count: min_worked_users.count,
      max_worked_users: max_worked_users,
      not_enough_users: min_not_enough
    }
  end

  private

  def users
    @users ||= Permission.users_by('projects:timer')
                         .with_deleted
                         .includes(:roles)
                         .where(users: { id: @users_ids }, roles: { id: @roles_ids })
  end

  def all_worklogs(user)
    @all_worklogs ||= Worklog.with_deleted
                             .select(:user_id, :date, 'sum(length) as time')
                             .where(date: @start..@end)
                             .group(:date, :user_id)
                             .group_by(&:user_id)
                             .transform_values { |v| v.map { |e| e.slice(:date, :time) } }
    @all_worklogs[user.id] || []
  end

  def paid_worklogs(user)
    @paid_worklogs ||= Worklog.with_deleted
                              .joins(:project)
                              .select(:user_id, :date, 'sum(length) as time')
                              .where(projects: { paid: true }, worklogs: { date: @start..@end })
                              .group(:date, :user_id)
                              .group_by(&:user_id)
                              .transform_values { |v| v.map { |e| e.slice(:date, :time) } }
    @paid_worklogs[user.id] || []
  end

  def plan(user)
    Users::WorktimeService.new(user, start_date: @start, finish_date: @end).working_time_by_dates
  end

  def worked_plan(user)
    Users::WorktimeService.new(user, start_date: @start, finish_date: @end).worked_out
  end
end
