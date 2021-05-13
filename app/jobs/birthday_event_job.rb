class BirthdayEventJob < ApplicationJob
  def perform(user)
    date = user.birthday.change(year: Date.current.year)
    event = Events::Common.at_date(date).where(user: user)
    return if event.present?
    Events::Common.create(user: user, started_at: date.beginning_of_day, ended_at: date.end_of_day,
                          all_day: true, title: "Birthday of #{user.full_name}",
                          description: "Age of #{Date.current.year - user.birthday.year}")
  end
end
