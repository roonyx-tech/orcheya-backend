class AddFavoriteToUsersAchievements < ActiveRecord::Migration[6.0]
  def change
    add_column :users_achievements, :favorite, :boolean, default: false
  end
end
