class CreateSkills < ActiveRecord::Migration[5.1]
  def change
    create_table :skills do |t|
      t.string :title
      t.bigint :difficulty_level_id
      t.text :variants, null: true
      t.boolean :approved, default: :false

      t.timestamps
    end
  end
end
