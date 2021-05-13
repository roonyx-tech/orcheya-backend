class CreateQuests < ActiveRecord::Migration[5.1]
  def change
    create_table :quests do |t|
      t.string :name
      t.text :short_description
      t.text :description
      t.text :rewards
      t.integer :author_id, index: true

      t.timestamps
    end

    create_table :quests_users do |t|
      t.belongs_to :quest, index: true
      t.belongs_to :user, index: true
    end
  end
end
