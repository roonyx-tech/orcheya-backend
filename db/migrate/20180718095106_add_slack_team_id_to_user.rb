class AddSlackTeamIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :slack_team_id, :string
    add_column :users, :slack_name, :string
  end
end
