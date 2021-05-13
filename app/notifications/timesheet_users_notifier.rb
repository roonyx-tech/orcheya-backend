class TimesheetUsersNotifier < BaseNotifier
  def pm_monday
    date = Time.zone.today - 1.week
    @data = TimesheetReport.week_report(date.beginning_of_week, date.end_of_week)

    Permission.users_by('notifications:pm_monday').each do |user|
      notify(action: :pm_monday, recipient: user)
    end
  end
end
