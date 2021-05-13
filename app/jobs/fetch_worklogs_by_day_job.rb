class FetchWorklogsByDayJob < ApplicationJob
  queue_as :worklogs

  def perform(user, day = Time.zone.now.to_date.to_s)
    return if user.timedoctor_token.nil?
    td = TimeDoctorService.new(user)
    td.fetch_worklogs day
  end
end
