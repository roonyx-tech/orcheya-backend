class ReplaceUserIdToSlackIdFromUpdates < ActiveRecord::Migration[5.1]
  def change
    remove_column :updates, :user_id, :integer
    add_column :updates, :slack_id, :string
  end
end
