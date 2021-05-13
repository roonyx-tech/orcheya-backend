class CreateAchievementLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :achievement_levels do |t|
      t.integer :number
      t.integer :from
      t.integer :to
      t.string :name
      t.string :color
      t.belongs_to :achievement
      t.timestamps
    end
  end
end
