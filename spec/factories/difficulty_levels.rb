# == Schema Information
#
# Table name: difficulty_levels
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :difficulty_level do
    title { Faker::Lorem.word }
    value { Faker::Number.between(from: 3, to: 9) }
  end
end
