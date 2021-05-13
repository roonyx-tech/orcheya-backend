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

class DifficultyLevelSerializer < ActiveModel::Serializer
  attributes :id, :title, :value
end
