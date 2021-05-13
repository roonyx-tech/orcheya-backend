class VacationNotifier < BaseNotifier
  def create
    users = Permission.users_by('calendar:vacation')
    users.map { |user| notify(action: :create, recipient: user) }
  end

  def update
    users = Permission.users_by('calendar:vacation')
    users.map { |user| notify(action: :update, recipient: user) }
  end

  def destroy
    users = Permission.users_by('calendar:vacation')
    users.map { |user| notify(action: :destroy, recipient: user) }
  end

  def approve
    notify(recipient: options.event.user)
  end

  def approve_vacation
    channel_notify(channel: :vacation, action: :approve_vacation)
  end

  def disapprove
    notify(recipient: options.event.user)
  end

  def without_vacations
    @users = []
    User.where(vacation_notifier_disabled: false).each do |user|
      next if (Time.zone.today - user.employment_at).to_i < 180
      @users << user if user.vacations.approved.overlap(180.days.ago, Time.zone.today).blank?
    end

    return if @users.blank?
    Role.find_by(name: 'HR').users.each do |user|
      notify(action: :without_vacations, recipient: user)
    end
  end
end
