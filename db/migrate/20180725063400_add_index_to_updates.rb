class AddIndexToUpdates < ActiveRecord::Migration[5.1]
  def change
    add_index :updates, [:user_id, :date], unique: true
  end
end
