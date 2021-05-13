class RefreshVacationDaysUsed < ActiveRecord::Migration[6.0]
  def up
    Events::Vacation.all.uniq(&:user_id).each do |vacation|
      vacation.send :refresh_vacation_days_used!
      vacation.save!
    end
  end
end
