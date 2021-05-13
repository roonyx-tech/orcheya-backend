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

FactoryBot.define do
  factory :skill do
    title { Faker::Job.key_skill }
    difficulty_level { DifficultyLevel.random }
    variants { Faker::Job.key_skill }
    approved { true }
  end
end
