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

class DifficultyLevel < ApplicationRecord
  has_many :skills, dependent: :restrict_with_error

  validates :title, :value, presence: true
end
