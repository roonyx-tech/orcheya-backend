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

class AchievementLevel < ApplicationRecord
  belongs_to :achievement
  validates :from, :to, :name, :color, :second_color, :third_color, :number, presence: true

  validate :score_from
  validate :score_to
  validate :from_less_than_to
  validate :without_gaps_from
  validate :without_gaps_to

  def from_less_than_to
    return if from < to
    errors.add :base, "Level #{number}: first value (from) must be less than second value (to)"
  end

  def without_gaps_from
    prev_level = achievement.levels.to_a.select { |l| l.number == (number - 1) }.first
    return if prev_level.blank?
    return if from == prev_level.to + 1

    errors.add :from, "Score 'from' of the #{number} level must be greater by 1 than score 'to' of previous level"
  end

  def without_gaps_to
    next_level = achievement.levels.to_a.select { |l| l.number == (number + 1) }.first
    return if next_level.blank?
    return if to == next_level.from - 1

    errors.add :to, "Score 'to' of the #{number} level must be less by 1 than score 'from' of next level"
  end

  def score_from
    prev_level = achievement.levels.to_a.select { |l| l.number == (number - 1) }.first
    return if prev_level.blank?
    return if from > prev_level.to

    errors.add :from, "Score range of the #{number} level overlapped with another level"
  end

  def score_to
    next_level = achievement.levels.to_a.select { |l| l.number == (number + 1) }.first
    return if next_level.blank?
    return if to < next_level.from

    errors.add :to, "Score range of the #{number} level overlapped with another level"
  end
end
