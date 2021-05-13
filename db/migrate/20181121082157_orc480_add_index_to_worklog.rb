class Orc480AddIndexToWorklog < ActiveRecord::Migration[5.1]
  def up
    remove_index :worklogs, %i[task_id user_id project_id date]
    add_index :worklogs, %i[task_id date], unique: true
  end

  def dowm
    remove_index :worklogs, %i[task_id date]
    add_index :worklogs, %i[task_id user_id project_id date], unique: true
  end
end
