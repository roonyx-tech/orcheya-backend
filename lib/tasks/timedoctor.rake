namespace :timedoctor do
  namespace :worklogs do
    desc 'Fetch work logs by day'
    task day: :environment do
      User.where.not(timedoctor_token: nil).each do |user|
        FetchWorklogsByDayJob.perform_later(user)
      end
    end

    desc 'Fetch work logs by week'
    task week: :environment do
      User.where.not(timedoctor_token: nil).each do |user|
        FetchWorklogsByWeekJob.perform_later(user)
      end
    end

    desc 'Fetch work logs by year'
    task year: :environment do
      User.where.not(timedoctor_token: nil).each do |user|
        FetchWorklogsByYearJob.perform_later(user)
      end
    end

    desc 'Clear work logs'
    task clear: :environment do
      Worklog.timedoctors.delete_all
    end
  end
end
