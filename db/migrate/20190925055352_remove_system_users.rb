class RemoveSystemUsers < ActiveRecord::Migration[5.2]
  def up
    drop_table :apps
    User.where(system: true).delete_all
    remove_column :users, :system, :boolean, default: false
  end

  def down
    add_column :users, :system, :boolean, default: false
    create_table :apps do |t|
      t.string :client_id
      t.string :client_secret
      t.string :name
      t.boolean :approved
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
