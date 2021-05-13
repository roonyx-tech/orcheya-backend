class AddNotifyUpdateToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notify_update, :boolean, default: true
  end
end
