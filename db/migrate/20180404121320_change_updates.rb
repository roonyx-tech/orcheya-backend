class ChangeUpdates < ActiveRecord::Migration[5.1]
  def change
    add_column :updates, :made, :string
    add_column :updates, :planning, :string
    add_column :updates, :issues, :string
    add_column :updates, :user_id, :integer
    remove_column :updates, :text, :string
    remove_column :updates, :slack_id, :string
  end
end
