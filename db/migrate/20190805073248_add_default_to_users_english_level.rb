class AddDefaultToUsersEnglishLevel < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:users, :english_level, 0)
  end
end
