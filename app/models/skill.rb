# == Schema Information
#
# Table name: skills
#
#  id                  :bigint(8)        not null, primary key
#  title               :string
#  difficulty_level_id :bigint(8)
#  variants            :text
#  approved            :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  skill_type_id       :bigint(8)
#
# Indexes
#
#  index_skills_on_skill_type_id  (skill_type_id)
#

class Skill < ApplicationRecord
  has_many :users_skills, dependent: :destroy
  has_many :users, through: :users_skills
  belongs_to :difficulty_level
  belongs_to :skill_type, optional: true

  validates :title, presence: true

  scope :approved_skills, -> { where(approved: true) }
end
