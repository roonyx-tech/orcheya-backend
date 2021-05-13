class AddLastEnglishUpdateField < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_english_update, :date
  end
end
