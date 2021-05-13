class AddDefaultEnglishLevelToExistingEntries < ActiveRecord::Migration[5.1]
  def change
    User.update_all(english_level: 0)
  end
end
