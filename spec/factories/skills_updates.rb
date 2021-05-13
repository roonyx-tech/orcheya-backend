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

FactoryBot.define do
  factory :skills_update do
    users_skill { UsersSkill.random }
    level { Faker::Number.between(from: 1, to: 3) }
    approved { false }
    approver { User.random }
    comment { Faker::Lorem.paragraph }
  end
end
