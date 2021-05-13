class AddDiscordNameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :discord_name, :string
  end
end
