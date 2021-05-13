class FetchWorklogsByYearJob < ApplicationJob
  queue_as :worklogs

  def perform(user)
    today = Time.zone.now.to_date

    today.downto(today - 1.year) do |day|
      FetchWorklogsByDayJob.perform_later(user, day.to_s)
    end
  end
end
