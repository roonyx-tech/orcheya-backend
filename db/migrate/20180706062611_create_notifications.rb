class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.belongs_to :user
      t.string :text, null: false
      t.integer :importance, null: false, default: 2
      t.datetime :readed_at
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
