# == Schema Information
#
# Table name: sections
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string
#

FactoryBot.define do
  factory :section do
    title { Faker::Lorem.word }
  end
end
