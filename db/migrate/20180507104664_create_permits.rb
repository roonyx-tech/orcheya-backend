class CreatePermits < ActiveRecord::Migration[5.1]
  def change
    create_table :permits do |t|
      t.integer :user_id
      t.string :ability_id
    end

    add_index :permits, [:user_id, :ability_id], unique: true
  end
end
