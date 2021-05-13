class CreateApps < ActiveRecord::Migration[5.1]
  def change
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
