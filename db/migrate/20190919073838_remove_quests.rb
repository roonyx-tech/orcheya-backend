class RemoveQuests < ActiveRecord::Migration[5.2]
  def change
    drop_table :quests
    drop_table :quests_users
  end
end
