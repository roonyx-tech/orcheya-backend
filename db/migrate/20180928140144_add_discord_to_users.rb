class AddDiscordToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :discord_token, :string
    add_column :users, :discord_refresh_token, :string
    add_column :users, :discord_id, :string
    add_column :users, :discord_username, :string
    add_column :users, :discord_dm_id, :string
    add_column :users, :discord_notify_update, :boolean, default: true
  end
end
