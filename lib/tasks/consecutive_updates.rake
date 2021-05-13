namespace :consecutive_updates do
  desc 'Count consecutive updates for participants'
  task count: :environment do
    today = Time.zone.today
    return if today.saturday? || today.sunday? || Events::Holiday.at_date(today).present?
    Permission.find_by!(subject: :projects, action: :participant).users.invitation_accepted.each do |user|
      ConsecutiveUpdatesJob.perform_now(user)
    end
  end
end
