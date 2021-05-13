class CreateWorklogs < ActiveRecord::Migration[5.1]
  def change
    create_table :worklogs do |t|
      t.belongs_to :user
      t.integer :length
      t.integer :task_id
      t.string :task_name
      t.string :task_url
      t.date :date
      t.string :source
    end
  end
end
