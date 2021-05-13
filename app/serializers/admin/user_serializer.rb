# == Schema Information
#
# Table name: users
#
#  id                       :bigint(8)        not null, primary key
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :inet
#  last_sign_in_ip          :inet
#  failed_attempts          :integer          default(0), not null
#  unlock_token             :string
#  locked_at                :datetime
#  jti                      :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  name                     :string           default(""), not null
#  surname                  :string           default(""), not null
#  birthday                 :date
#  employment_at            :date
#  sex                      :integer
#  github                   :string
#  bitbucket                :string
#  skype                    :string
#  phone                    :string
#  invitation_token         :string
#  invitation_created_at    :datetime
#  invitation_sent_at       :datetime
#  invitation_accepted_at   :datetime
#  invitation_limit         :integer
#  invited_by_id            :integer
#  invited_by_type          :string
#  slack_id                 :string
#  avatar                   :string
#  temp_integration_token   :string
#  slack_token              :string
#  temp_referer             :string
#  timedoctor_token         :string
#  timedoctor_refresh_token :string
#  timedoctor_company_id    :integer
#  timedoctor_user_id       :integer
#  agreement_accepted       :boolean          default(FALSE)
#  registration_finished    :boolean          default(FALSE)
#  upwork_oauth_token       :string
#  upwork_access_secret     :string
#  upwork_user_id           :string
#  notify_update            :boolean          default(TRUE)
#  timing_id                :integer
#  role_id                  :integer
#  deleted_at               :datetime
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
#  fk_rails_...  (role_id => roles.id)
#

module Admin
  class UserSerializer < ActiveModel::Serializer
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
               :discord_name,
               :phone,
               :roles,
               :timing_id,
               :working_hours,
               :available_vacations_days,
               :about,
               :vacation_notifier_disabled

    belongs_to :timing, serializer: TimingIndexSerializer
  end
end
