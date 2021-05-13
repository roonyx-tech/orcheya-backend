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

class UsersSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill
  has_many :skills_updates, dependent: :destroy
  has_many :skill_last_update,
           -> { limit(1) },
           class_name: 'SkillsUpdate',
           foreign_key: :users_skill_id,
           inverse_of: :users_skill
  default_scope { order(level: :desc) }
  scope :has_level, -> { where.not(level: 0) }
end
