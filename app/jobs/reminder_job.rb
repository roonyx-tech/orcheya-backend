class ReminderJob < ApplicationJob
  def perform(user, attempt)
    date = Date.current
    return if user.updates.at(date).first

    UpdateNotifier.new(recipient: user, date: date, attempt: attempt).remind
  end
end
