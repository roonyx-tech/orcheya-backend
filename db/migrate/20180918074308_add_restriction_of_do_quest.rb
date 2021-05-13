class AddRestrictionOfDoQuest < ActiveRecord::Migration[5.1]
  def change
    add_column :quests, :restriction_on_people, :integer
  end
end
