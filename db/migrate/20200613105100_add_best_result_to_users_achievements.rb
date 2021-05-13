class AddBestResultToUsersAchievements < ActiveRecord::Migration[6.0]
  def change
    add_column :users_achievements, :best_result, :integer, default: 0
  end
end
