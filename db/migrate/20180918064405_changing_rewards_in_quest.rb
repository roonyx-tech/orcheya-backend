class ChangingRewardsInQuest < ActiveRecord::Migration[5.1]
  def up
    Quest.find_each do |q|
      q.update(rewards: q.rewards.to_f)
    end
    change_column :quests, :rewards, 'double precision USING rewards::double precision'
  end

  def down
    change_column :quests, :rewards, 'text USING rewards::text'
  end
end

class Quest < ApplicationRecord; end
