class Orc480FixWorklogs < ActiveRecord::Migration[5.1]
  def up
    remove_index :worklogs, %i[task_id date]
    add_index :worklogs, %i[task_id user_id project_id date], unique: true
    Worklog.with_deleted.find_by(id: 19977).try(:really_destroy!)
    Project.find_by(project_id: 1058217).worklogs.each do |w|
      w.update(project_id: 0)
    end
    project = Project.find_by(project_id: 1058217)
    UpdateProject.where(project_id: project.id).update_all(project_id: 0)
    project.try(:destroy)
  end

  def dowm
    remove_index :worklogs, %i[task_id user_id project_id date]
    add_index :worklogs, %i[task_id date], unique: true
  end
end
