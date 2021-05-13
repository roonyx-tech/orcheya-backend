class HolidayNotifier < BaseNotifier
  def day_before
    @tomorrow_events = check_holidays(Time.zone.tomorrow)
    return if @tomorrow_events.blank?

    User.invitation_accepted.map { |user| notify(action: :day_before, recipient: user) }
  end

  def week_before
    in_a_week = Time.zone.today + 1.week
    @in_a_week_events = check_holidays(in_a_week)
    return if @in_a_week_events.blank?

    channel_notify(channel: :general, action: :week_before)
  end

  def check_holidays(date)
    events = []
    return if (date.monday? || date.saturday? || date.sunday?) && holidays_at(date.prev_occurring(:friday)).present?

    holidays_at(date).each do |holiday|
      events << holiday
      next unless date.friday?
      holidays_between(date + 1.day, date + 3.days).each do |holiday_btw|
        events << holiday_btw
      end
    end
    events
  end

  def holidays_at(date)
    Events::Holiday.at_date(date)
  end

  def holidays_between(start_date, end_date)
    Events::Holiday.between(start_date, end_date)
  end
end
