# == Schema Information
#
# Table name: users_achievements
#
#  id             :bigint(8)        not null, primary key
#  user_id        :bigint(8)
#  achievement_id :bigint(8)
#  level          :integer          default(1)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  score          :integer          default(0)
#  best_result    :integer          default(0)
#  favorite       :boolean          default(FALSE)
#
# Indexes
#
#  index_users_achievements_on_achievement_id  (achievement_id)
#  index_users_achievements_on_user_id         (user_id)
#

class UsersAchievementSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :achievement_id, :level, :score, :image, :kind, :achievement_title, :level_title,
             :next_level_score, :created_at, :color, :second_color, :third_color, :best_result

  def achievement_title
    object.achievement.title
  end

  def level_title
    return if object.achievement.levels.blank? || object.level.blank?
    object.achievement.levels.find_by(number: object.level)&.name
  end

  def next_level_score
    return if object.achievement.levels.blank? || object.level.blank?
    object.achievement.levels.find_by(number: object.level)&.to
  end

  def image
    object.achievement.image
  end

  def kind
    object.achievement.kind
  end

  def color
    return if object.achievement.levels.blank? || object.level.blank?
    object.achievement.levels.find_by(number: object.level)&.color
  end

  def second_color
    return if object.achievement.levels.blank? || object.level.blank?
    object.achievement.levels.find_by(number: object.level)&.second_color
  end

  def third_color
    return if object.achievement.levels.blank? || object.level.blank?
    object.achievement.levels.find_by(number: object.level)&.third_color
  end
end
