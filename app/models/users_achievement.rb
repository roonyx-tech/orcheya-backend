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

class UsersAchievement < ApplicationRecord
  COUNTERS = %w[consecutive_updates working_days].freeze

  belongs_to :user
  belongs_to :achievement
  validates :achievement_id, uniqueness: { scope: :user_id }
  validate :only_one_favorite

  after_update :set_level

  def set_score
    new_score = send(achievement.endpoint)
    if new_score > best_result
      update(score: new_score, best_result: new_score)
    else
      new_score.positive? ? update(score: new_score) : update(score: 0)
    end
  end

  def clean_favorites
    favorite = user.users_achievements.find_by(favorite: true)
    favorite.update(favorite: false) if favorite.present?
  end

  private

  def only_one_favorite
    return if favorite == false || new_record?
    favorite = user.users_achievements.find_by(favorite: true)
    return if favorite.blank? || self == favorite
    errors.add :favorite, 'User can have only one favorite achievement'
  end

  def set_level
    return unless saved_change_to_best_result?
    achievement.levels.each do |level|
      update(level: level.number) if (level.from..level.to).cover?(best_result)
    end
  end

  def consecutive_updates
    user.consecutive_updates_count
  end

  def working_days
    employment_at = user.employment_at || user.created_at
    (Time.zone.today - employment_at.to_date).to_i
  end
end
