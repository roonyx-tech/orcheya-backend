class CreateCommits < ActiveRecord::Migration[5.2]
  def change
    create_table :commits do |t|
      t.string :message
      t.string :uid
      t.datetime :time
      t.string :url
      t.references :user, foreign_key: true
      t.string :project_name
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
