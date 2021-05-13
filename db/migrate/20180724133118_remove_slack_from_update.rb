class RemoveSlackFromUpdate < ActiveRecord::Migration[5.1]
  def change
    remove_column :updates, :slack_ts
    remove_column :updates, :status
  end
end
