class RefreshVacationsAndEvents < ActiveRecord::Migration[6.0]
  def change
    Events::Vacation.all.each { |event| event.update(started_at: event.started_at.beginning_of_day, ended_at: event.ended_at.end_of_day) }
    Events::Vacation.all.each(&:refresh_vacation_days_used!)
  end
end
