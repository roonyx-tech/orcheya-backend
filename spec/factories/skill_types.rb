# == Schema Information
#
# Table name: skill_types
#
#  id         :bigint(8)        not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :skill_type do
    title { Faker::Lorem.word }
  end
end
