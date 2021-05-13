# == Schema Information
#
# Table name: achievement_levels
#
#  id             :bigint(8)        not null, primary key
#  number         :integer
#  from           :integer
#  to             :integer
#  name           :string
#  color          :string
#  achievement_id :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  second_color   :string
#  third_color    :string
#
# Indexes
#
#  index_achievement_levels_on_achievement_id  (achievement_id)
#

class AchievementLevelSerializer < ActiveModel::Serializer
  attributes :id, :number, :from, :to, :color, :second_color, :third_color, :name
end
