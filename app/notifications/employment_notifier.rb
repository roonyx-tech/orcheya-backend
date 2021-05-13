class EmploymentNotifier < BaseNotifier
  def congratulate_employment
    today_date = Date.current
    @users = users_on(today_date)

    return if @users.empty?

    channel_notify(channel: :general, action: :congratulate_employment)
    User.where.not(id: @users.ids).map { |user| notify(action: :remind_by_day_employment, recipient: user) }
  end

  def remind_employment
    today_date = Date.current + 7.days
    @users = users_on(today_date)

    return if @users.empty?

    User.where.not(id: @users.ids).map { |user| notify(action: :remind_employment, recipient: user) }
  end

  def all
    [
      congratulate_employment,
      remind_employment
    ].flatten.compact
  end

  private

  def users_on(date)
    User.where("date_part('month', employment_at) = ? AND date_part('day', employment_at) = ?", date.month, date.day)
  end
end
