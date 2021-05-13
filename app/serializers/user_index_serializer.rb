# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  jti                    :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  name                   :string(20)       default(""), not null
#  surname                :string(20)       default(""), not null
#  birthday               :date
#  employment_at          :date
#  sex                    :integer
#  github                 :string(30)
#  bitbucket              :string(30)
#  skype                  :string(30)
#  phone                  :string(20)
#  timing                 :integer
#  avatar                 :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class UserIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :surname, :name_cyrillic, :surname_cyrillic, :title, :email, :phone, :avatar, :timing_id,
             :birthday, :deleted_at, :favorite_achievement

  belongs_to :timing, serializer: TimingIndexSerializer
  has_many :users_skills
  has_many :roles, serializer: RoleShortSerializer

  def title
    "#{object.name} #{object.surname}"
  end

  def favorite_achievement
    achievement = object.users_achievements.find_by(favorite: true)
    achievement = object.users_achievements.first if achievement.blank?
    UsersAchievementSerializer.new(achievement) if achievement.present?
  end
end
