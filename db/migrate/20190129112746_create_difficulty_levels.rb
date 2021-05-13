class CreateDifficultyLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :difficulty_levels do |t|
      t.string :title
      t.integer :value

      t.timestamps
    end
  end
end
