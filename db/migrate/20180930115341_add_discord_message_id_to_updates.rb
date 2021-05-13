class AddDiscordMessageIdToUpdates < ActiveRecord::Migration[5.1]
  def change
    add_column :updates, :discord_message_id, :string
  end
end
