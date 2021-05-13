class UpdatesReport
  def self.report(start_date, end_date)
    new(start_date, end_date).report
  end

  def self.without_updates(start_date, end_date, users_ids)
    new(start_date, end_date, users_ids).without_updates
  end

  def initialize(start_date = nil, end_date = nil, users_ids = nil)
    @today = Time.zone.today
    @start_date = start_date&.to_date || @today - 3.months
    @end_date = end_date&.to_date || @today
    @end_date = @end_date > @today ? @today : @end_date

    @dates = (@start_date..@end_date).to_a.reverse
    @users = Permission.find_by(subject: 'notifications', action: 'remind_update').users
    @users = @users.where(id: users_ids) if users_ids.present?
  end

  def without_updates
    no_updates = []
    @dates.each do |date|
      next if date.on_weekend?
      users = @users.at_date(date)
      without_update = []
      users.each do |u|
        next if Events::Vacation.approved.overlap(date.beginning_of_day, date.end_of_day).where(user: u).present?
        without_update << UserShortInfoSerializer.new(u).as_json if u.updates.at_date(date).blank?
      end
      no_updates << { date: date, users_without_update: without_update } if without_update.present?
    end

    no_updates
  end

  def report
    report = []

    @dates.each do |date|
      next if date.on_weekend?
      users = @users.at_date(date)
      with_update = 0
      users_on_vacation = 0
      users.each do |u|
        if Events::Vacation.approved.overlap(date.beginning_of_day, date.end_of_day).where(user: u).present?
          users_on_vacation += 1
          next
        end
        with_update += 1 if u.updates.at_date(date).present?
      end
      percent = (with_update.to_f / (users.count - users_on_vacation)) * 100
      report << { date: date, complete_percent: percent }
    end

    report
  end
end
