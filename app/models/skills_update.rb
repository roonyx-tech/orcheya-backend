# == Schema Information
#
# Table name: skills_updates
#
#  id             :bigint(8)        not null, primary key
#  users_skill_id :bigint(8)
#  level          :integer
#  approved       :boolean
#  approver_id    :bigint(8)
#  comment        :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class SkillsUpdate < ApplicationRecord
  belongs_to :users_skill
  belongs_to :approver, class_name: 'User'

  default_scope { order(created_at: :desc) }
  validates :level, presence: true

  after_update :update_skill_level, if: -> { approved && saved_change_to_attribute?(:approved) }

  def update_skill_level
    users_skill.update(level: level)
  end
end
