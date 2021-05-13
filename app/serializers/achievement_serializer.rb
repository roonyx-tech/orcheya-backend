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

class AchievementSerializer < ActiveModel::Serializer
  attributes :id, :title, :kind, :image, :levels, :endpoint
end
