# == Schema Information
#
# Table name: users_achievements
#
#  id             :bigint(8)        not null, primary key
#  user_id        :bigint(8)
#  achievement_id :bigint(8)
#  level          :integer          default(1)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  score          :integer          default(0)
#  best_result    :integer          default(0)
#  favorite       :boolean          default(FALSE)
#
# Indexes
#
#  index_users_achievements_on_achievement_id  (achievement_id)
#  index_users_achievements_on_user_id         (user_id)
#

FactoryBot.define do
  factory :users_achievement do
    user { User.random }
    achievement { Achievement.random }
    level { (1..7).sample }
  end
end
