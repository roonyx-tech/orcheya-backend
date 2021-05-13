class AddSystemToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :system, :boolean
    change_column :apps, :approved, :boolean, default: true
  end
end
