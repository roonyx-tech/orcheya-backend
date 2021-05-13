class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :started_at
      t.datetime :ended_at
      t.boolean :all_day
      t.belongs_to :user
      t.timestamps
    end
  end
end
