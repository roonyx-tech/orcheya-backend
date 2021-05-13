# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

every 30.minutes do
  rake 'timedoctor:worklogs:day'
end

every :day, at: '8:00am' do
  runner 'BirthdayNotifier.notify(:all)'
end

every :day, at: '11:50pm' do
  rake 'consecutive_updates:count'
  rake 'achievements:set_score'
end

every :weekdays, at: '4:00pm' do
  rake 'update:remind'
end

every :monday, at: '10:00am' do
  runner 'TimesheetUsersNotifier.notify(:pm_monday)'
  runner 'VacationNotifier.notify(:without_vacations)'
  rake 'update_demo:run'
end

every :friday, at: '10:00pm' do
  rake 'timedoctor:worklogs:week'
end
