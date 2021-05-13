class CreateAchievementsRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :achievements_roles do |t|
      t.references :achievement
      t.references :role
      t.timestamps
    end
  end
end
