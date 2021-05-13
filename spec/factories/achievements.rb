# == Schema Information
#
# Table name: achievements
#
#  id         :bigint(8)        not null, primary key
#  title      :string           not null
#  kind       :integer
#  image      :string
#  endpoint   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :achievement do
    title { Faker::Lorem.word }
    kind { %w[manual auto].sample }
    image { 'uri_to_image.jpg' }
    endpoint { 'counter_name' }
  end
end
