class NewDifficultyLevels < ActiveRecord::Migration[5.1]
  def up
    Rake::Task['difficulty_levels:load'].invoke
  end
end
