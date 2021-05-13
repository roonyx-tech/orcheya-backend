class AddProjectIdToWorklog < ActiveRecord::Migration[5.1]
  def change
    add_column :worklogs, :project_id, :integer, null: false, default: 0
  end
end
