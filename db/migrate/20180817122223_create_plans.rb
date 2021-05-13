class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :title
      t.datetime :started_at
      t.datetime :ended_at
      t.datetime :deleted_at, index: true
      t.belongs_to :user
      t.belongs_to :project
      t.timestamps
    end

    add_index :plans, [:user_id, :project_id]
  end
end
