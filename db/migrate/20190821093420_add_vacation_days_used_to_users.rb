class AddVacationDaysUsedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :vacation_days_used, :integer, default: 0
  end
end
