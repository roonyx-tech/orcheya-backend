class AddStartTimeEndtimeToWorklogs < ActiveRecord::Migration[5.1]
  def change
    add_column :worklogs, :source_id, :integer
    add_column :worklogs, :start_time, :datetime
    add_column :worklogs, :end_time, :datetime
    remove_index :worklogs, %i[task_id date]
  end
end
