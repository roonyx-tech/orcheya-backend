class ProfileSerializer < ActiveModel::Serializer
  attributes :id,
             :avatar,
             :email,
             :name,
             :surname,
             :name_cyrillic,
             :surname_cyrillic,
             :birthday,
             :employment_at,
             :sex,
             :skype,
             :phone,
             :timing_id,
             :discord_connected,
             :discord_name,
             :slack_connected,
             :timedoctor_connected,
             :registration_finished,
             :roles,
             :permissions,
             :notify_update,
             :slack_id,
             :slack_team_id,
             :slack_name,
             :discord_id,
             :discord_username,
             :discord_dm_id,
             :discord_notify_update,
             :vacation_days_used,
             :available_vacations_days,
             :english_level,
             :working_hours,
             :last_english_update,
             :about,
             :favorite_achievement

  belongs_to :timing, serializer: TimingIndexSerializer
  has_many :notifications

  def favorite_achievement
    achievement = object.users_achievements.find_by(favorite: true)
    achievement = object.users_achievements.first if achievement.blank?
    UsersAchievementSerializer.new(achievement) if achievement.present?
  end

  def discord_connected
    object.discord_connected?
  end

  def slack_connected
    object.slack_connected?
  end

  def timedoctor_connected
    object.timedoctor_connected?
  end
end
