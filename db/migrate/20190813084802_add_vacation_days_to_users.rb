class AddVacationDaysToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :vacation_days, :integer, default: 0
  end
end
