class ShiftIdOnProject < ActiveRecord::Migration[5.1]
  def self.up
    add_column :projects, :project_id, :integer
    Project.update_all('project_id = id')

    max_id = Project.ids.max
    max_id = max_id > 0 ? max_id : 1
    ActiveRecord::Base.connection.execute("SELECT setval('projects_id_seq', #{max_id});")
  end

  def self.down
    remove_column :projects, :project_id
  end
end

