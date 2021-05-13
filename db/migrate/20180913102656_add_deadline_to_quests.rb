class AddDeadlineToQuests < ActiveRecord::Migration[5.1]
  def change
    add_column :quests, :deadline, :datetime
  end
end
