namespace :update do
  desc 'Send update reminder to user'
  task remind: :environment do
    next if Events::Holiday.at_date(Date.current).present?

    Permission.users_by('notifications:remind_update').discord_connected?.includes(:timing).each do |user|
      next unless Users::DaysService.workday?(user)
      timing = user.timing
      if timing
        wait_until = timing.flexible? ? 19.hours : timing.to - 30.minutes
      else
        wait_until = 19.hours
      end

      ReminderJob.set(wait_until: wait_until).perform_later(user, 'first')
      ReminderJob.set(wait_until: wait_until + 20.minutes).perform_later(user, 'second')
      ReminderJob.set(wait_until: wait_until + 60.minutes).perform_later(user, 'third')
    end
  end
end
