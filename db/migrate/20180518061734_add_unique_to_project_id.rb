class AddUniqueToProjectId < ActiveRecord::Migration[5.1]
  def change
    add_index :projects, :project_id, unique: true
  end
end
