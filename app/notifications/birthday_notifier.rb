class BirthdayNotifier < BaseNotifier
  def congratulate
    today_date = Date.current
    @users = User.where(
      "date_part('month', birthday) = ? AND date_part('day', birthday) = ?",
      today_date.month,
      today_date.day
    )
    return if @users.empty?

    channel_notify(channel: :general, action: :congratulate)
    User.where.not(id: @users.ids).map { |user| notify(action: :remind_by_day, recipient: user) }
  end

  def remind
    dates = [Date.current + 3.days, Date.current + 7.days].map { |date| date.strftime('%d-%m') }

    @users = User.where('to_char(birthday, \'DD-MM\') in (?)', dates)
    return if @users.empty?

    User.where.not(id: @users.ids).map { |user| notify(action: :remind, recipient: user) }
  end

  def all
    [
      congratulate,
      remind
    ].flatten.compact
  end
end
