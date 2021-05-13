class CreateSkillsUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :skills_updates do |t|
      t.bigint :users_skill_id
      t.integer :level
      t.boolean :approved, null: true
      t.bigint :approver_id, null: true
      t.text :comment, null: true

      t.timestamps
    end
  end
end
