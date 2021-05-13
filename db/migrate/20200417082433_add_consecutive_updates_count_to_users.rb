class AddConsecutiveUpdatesCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :consecutive_updates_count, :integer, default: 0
  end
end
