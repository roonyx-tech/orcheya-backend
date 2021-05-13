# == Schema Information
#
# Table name: achievements_roles
#
#  id             :bigint(8)        not null, primary key
#  achievement_id :bigint(8)
#  role_id        :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_achievements_roles_on_achievement_id  (achievement_id)
#  index_achievements_roles_on_role_id         (role_id)
#

FactoryBot.define do
  factory :achievements_role do
  end
end
