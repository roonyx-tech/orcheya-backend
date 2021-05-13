class AddDoneToQuestsUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :quests_users, :done, :boolean, default: false
  end
end
