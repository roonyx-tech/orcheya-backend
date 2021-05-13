class CreatePermissionSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :permission_subjects do |t|
      t.string :name
      t.string :title
      t.string :description
    end
  end
end
