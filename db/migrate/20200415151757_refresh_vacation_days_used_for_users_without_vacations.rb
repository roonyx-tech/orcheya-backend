class RefreshVacationDaysUsedForUsersWithoutVacations < ActiveRecord::Migration[6.0]
  def up
    User.invitation_accepted.each do |user|
      user.update!(vacation_days_used: 0) if user.vacations == []
    end
  end
end
