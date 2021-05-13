class AddIsDeveloperToRole < ActiveRecord::Migration[5.1]
  def change
    add_column :roles, :is_developer, :boolean, default: false, null: false
  end
end
