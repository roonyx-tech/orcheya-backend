class RemoveVacationDaysInitialAtFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :vacation_days_initial_at, :date
    User.update_all(vacation_days_initial: 0)
  end
end
