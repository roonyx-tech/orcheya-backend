class CreateUsersSkill < ActiveRecord::Migration[5.1]
  def change
    create_table :users_skills do |t|
      t.bigint :user_id
      t.bigint :skill_id
      t.integer :level, default: 0

      t.timestamps
    end
  end
end
