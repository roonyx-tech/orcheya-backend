class AddEnglishLevelToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :english_level, :integer
  end
end
