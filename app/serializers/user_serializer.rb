# == Schema Information
#
# Table name: users
#
#  id                         :bigint(8)        not null, primary key
#  email                      :string           default(""), not null
#  encrypted_password         :string           default(""), not null
#  reset_password_token       :string
#  reset_password_sent_at     :datetime
#  remember_created_at        :datetime
#  sign_in_count              :integer          default(0), not null
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :inet
#  last_sign_in_ip            :inet
#  failed_attempts            :integer          default(0), not null
#  unlock_token               :string
#  locked_at                  :datetime
#  jti                        :string           not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  name                       :string           default(""), not null
#  surname                    :string           default(""), not null
#  birthday                   :date
#  employment_at              :date
#  sex                        :integer
#  skype                      :string
#  phone                      :string
#  invitation_token           :string
#  invitation_created_at      :datetime
#  invitation_sent_at         :datetime
#  invitation_accepted_at     :datetime
#  invitation_limit           :integer
#  invited_by_id              :integer
#  invited_by_type            :string
#  avatar                     :string
#  slack_id                   :string
#  temp_integration_token     :string
#  slack_token                :string
#  temp_referer               :string
#  timedoctor_token           :string
#  timedoctor_refresh_token   :string
#  timedoctor_company_id      :integer
#  timedoctor_user_id         :integer
#  agreement_accepted         :boolean          default(FALSE)
#  registration_finished      :boolean          default(FALSE)
#  upwork_oauth_token         :string
#  upwork_access_secret       :string
#  upwork_user_id             :string
#  notify_update              :boolean          default(TRUE)
#  deleted_at                 :datetime
#  timing_id                  :integer
#  slack_team_id              :string
#  slack_name                 :string
#  discord_token              :string
#  discord_refresh_token      :string
#  discord_id                 :string
#  discord_username           :string
#  discord_dm_id              :string
#  discord_notify_update      :boolean          default(TRUE)
#  english_level              :integer          default(0)
#  working_hours              :integer          default(35)
#  vacation_days_initial      :integer          default(0)
#  last_english_update        :date
#  vacation_days_used         :integer          default(0)
#  about                      :text
#  consecutive_updates_count  :integer          default(0)
#  vacation_notifier_disabled :boolean          default(FALSE)
#  name_cyrillic              :string
#  surname_cyrillic           :string
#  discord_name               :string
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (timing_id => timings.id)
#

class UserSerializer < UserShortInfoSerializer
  attributes :email,
             :birthday,
             :employment_at,
             :sex,
             :skype,
             :phone,
             :roles,
             :slack_id,
             :slack_team_id,
             :slack_name,
             :discord_id,
             :discord_username,
             :discord_dm_id,
             :discord_notify_update,
             :discord_name,
             :english_level,
             :last_english_update,
             :available_vacations_days,
             :working_hours,
             :about,
             :name_cyrillic,
             :surname_cyrillic

  belongs_to :timing, serializer: TimingIndexSerializer
end
