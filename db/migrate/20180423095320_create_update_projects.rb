class CreateUpdateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :update_projects do |t|
      t.references :update, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true

      t.timestamps
    end
  end
end
