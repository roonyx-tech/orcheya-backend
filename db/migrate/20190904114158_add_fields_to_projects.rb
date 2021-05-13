class AddFieldsToProjects < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :manager, foreign_key: { to_table: :users }
    change_column :projects, :paid, :boolean, null: false, default: false
    add_column :projects, :archived, :boolean, null: false, default: false
    add_column :projects, :title, :string
  end
end
