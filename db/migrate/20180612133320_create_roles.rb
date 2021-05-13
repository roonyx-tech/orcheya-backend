class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.boolean :is_admin, default: false, null: false
    end

    add_column :users, :role_id, :integer
    add_foreign_key :users, :roles, column: :role_id, primary_key: :id

    remove_column :users, :role
  end
end
