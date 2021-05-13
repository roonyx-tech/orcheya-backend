class CreateAchievements < ActiveRecord::Migration[6.0]
  def change
    create_table :achievements do |t|
      t.string :title, null: false
      t.integer :kind
      t.string :image
      t.text :levels
      t.string :endpoint
      t.timestamps
    end
  end
end
