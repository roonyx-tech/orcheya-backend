class DeleteLevelsFromAchievements < ActiveRecord::Migration[6.0]
  def change
    remove_column :achievements, :levels, :string
  end
end
