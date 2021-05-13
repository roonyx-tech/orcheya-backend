class AddScoresToUsersAchievements < ActiveRecord::Migration[6.0]
  def change
    add_column :users_achievements, :score, :integer, default: 0
  end
end
