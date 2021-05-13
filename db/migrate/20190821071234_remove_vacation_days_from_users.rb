class RemoveVacationDaysFromUsers < ActiveRecord::Migration[5.1]
  def up
    remove_column :users, :vacation_days, :integer, default: 0
    remove_column :users, :work_start_date, :datetime
    add_column :users, :vacation_days_initial_at, :date
    User.where(employment_at: nil).update_all('employment_at = created_at')
  end

  def down
    add_column :users, :vacation_days, :integer, default: 0
    add_column :users, :work_start_date, :datetime
  end
end
