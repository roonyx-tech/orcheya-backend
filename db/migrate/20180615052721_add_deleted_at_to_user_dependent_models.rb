class AddDeletedAtToUserDependentModels < ActiveRecord::Migration[5.1]
  def change
    add_column :updates, :deleted_at, :datetime
    add_index :updates, :deleted_at

    add_column :worklogs, :deleted_at, :datetime
    add_index :worklogs, :deleted_at

    add_column :permits, :deleted_at, :datetime
    add_index :permits, :deleted_at

    add_column :update_projects, :deleted_at, :datetime
    add_index :update_projects, :deleted_at
  end
end
