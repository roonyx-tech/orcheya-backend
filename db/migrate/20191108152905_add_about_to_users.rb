class AddAboutToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :about, :text, limit: 400
  end
end
