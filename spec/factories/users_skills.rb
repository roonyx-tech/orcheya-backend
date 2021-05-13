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

FactoryBot.define do
  factory :users_skill do
    user { User.random }
    skill { Skill.random }
    level { Faker::Number.between(from: 1, to: 3) }

    trait :approved do
      after(:create) do |users_skill|
        create :skills_update, users_skill: users_skill, level: users_skill.level, approved: true
      end
    end
  end
end
