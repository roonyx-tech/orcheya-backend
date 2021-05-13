class CreateUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :updates do |t|
      t.datetime :date
      t.string :text
      t.belongs_to :user
      t.timestamps
    end
  end
end
