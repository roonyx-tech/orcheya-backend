class AddDeletedToRelationalModels < ActiveRecord::Migration[5.1]
  def change
    add_column :quests_users, :deleted_at, :datetime
    add_index :quests_users, :deleted_at
    add_column :roles_users, :deleted_at, :datetime
    add_index :roles_users, :deleted_at
  end
end
