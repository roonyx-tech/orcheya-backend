class AddDefaultToUsersAchievementLevel < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:users_achievements, :level, 1)
  end
end
