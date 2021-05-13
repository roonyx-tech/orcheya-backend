class ConsecutiveUpdatesJob < ApplicationJob
  def perform(user)
    today = Time.zone.today
    return if Events::Vacation.approved.overlap(today, today).where(user: user).present?
    if user.updates.start_date(today).present?
      user.increment(:consecutive_updates_count).save
    else
      user.update(consecutive_updates_count: 0)
    end
  end
end
