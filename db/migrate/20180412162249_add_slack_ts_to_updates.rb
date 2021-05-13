class AddSlackTsToUpdates < ActiveRecord::Migration[5.1]
  def change
    add_column :updates, :slack_ts, :string
  end
end
