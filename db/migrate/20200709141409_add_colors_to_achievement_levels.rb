class AddColorsToAchievementLevels < ActiveRecord::Migration[6.0]
  def change
    add_column :achievement_levels, :second_color, :string
    add_column :achievement_levels, :third_color, :string
  end
end
