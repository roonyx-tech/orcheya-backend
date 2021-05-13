namespace :worklogs do
  desc 'Remove worklogs for the last week'
  task recreating: :environment do
    date = Date.current

    Worklog.with_deleted.where(date: date - 7.days..date).each do |worklog|
      worklog.really_destroy!
    end
    Rake::Task['timedoctor:worklogs:week'].invoke
  end
end
