class AddWorkingHoursToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :working_hours, :integer, default: 35
  end
end
