class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.timestamps
    end
    Project.create(id: 0, name: 'Non JIRA tasks')
  end
end
