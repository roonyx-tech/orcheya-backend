class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :text, null: false
      t.references :project, index: true, null: false

      t.timestamps
    end
  end
end
