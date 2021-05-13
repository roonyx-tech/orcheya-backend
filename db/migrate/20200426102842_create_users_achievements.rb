class CreateUsersAchievements < ActiveRecord::Migration[6.0]
  def change
    create_table :users_achievements do |t|
      t.references :user
      t.references :achievement
      t.integer :level
      t.timestamps
    end
  end
end
