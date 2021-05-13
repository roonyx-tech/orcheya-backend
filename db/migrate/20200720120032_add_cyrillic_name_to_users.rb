class AddCyrillicNameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name_cyrillic, :string
    add_column :users, :surname_cyrillic, :string
  end
end
