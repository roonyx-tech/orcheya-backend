class AddStatusToUpdates < ActiveRecord::Migration[5.1]
  def change
    add_column :updates, :status, :integer, default: 0
  end
end
