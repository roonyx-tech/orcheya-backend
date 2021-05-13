# == Schema Information
#
# Table name: notifications
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  text       :string           not null
#  importance :integer          default("medium"), not null
#  readed_at  :datetime
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_notifications_on_deleted_at  (deleted_at)
#  index_notifications_on_user_id     (user_id)
#

FactoryBot.define do
  factory :notification do
    text { Faker::Lorem.paragraph }
    importance { Faker::Number.between(from: 1, to: 4) }
  end
end
