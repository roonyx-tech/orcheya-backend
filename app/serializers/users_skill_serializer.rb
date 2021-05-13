# == Schema Information
#
# Table name: users_skills
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  skill_id   :bigint(8)
#  level      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UsersSkillSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :skill_id, :level

  belongs_to :skill
end
