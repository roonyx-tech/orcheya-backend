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

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{surname}#{n}@email.com" }
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
    employment_at { Faker::Date.between(from: 2.years.ago, to: Time.zone.today) }
    sex { Faker::Number.between(from: 1, to: 2) }
    skype { Faker::Internet.user_name(specifier: 5..8) }
    phone { Faker::Number.between(from: 81_000_000_000, to: 89_999_999_999) }
    timing { Timing.all.sample }
    jti { SecureRandom.uuid }
    discord_name { Faker::Internet.user_name(specifier: 5..8) }
    created_at { Time.zone.today.beginning_of_month }
    # Because because it clogs the disk
    unless Rails.env.test?
      avatar do |user|
        file = user.sex.eql?(1) ? generate(:avatar_file_man) : generate(:avatar_file_woman)
        Rack::Test::UploadedFile.new(file, 'image/jpeg')
      end
    end
    password { '123456' }
    working_hours { 35 }
    registration_finished { true }
    english_level { 1 }
    last_english_update { Faker::Date.backward(days: 14) }
    transient do
      permissions { [] }
    end

    after(:create) do |user, evalutor|
      if evalutor.permissions.any?
        permissions = []
        evalutor.permissions.each do |subject, actions|
          [*actions].each { |action| permissions << Permission.find_or_create_by(subject: subject, action: action) }
        end
        user.roles << create(:role, permissions: permissions)
      end
    end

    sequence(:slack_id) { |n| "#{SecureRandom.hex(8)}#{n}" }
    slack_token { 'SLACK_TOKEN' }

    trait :no_avatar do
      avatar { nil }
    end

    trait :invited do
      before(:create, &:invite!)
    end

    trait :with_role do
      roles { [Role.random].compact }
    end

    trait :invite_accepted do
      after(:create) do |user|
        user.update password: '123456', invitation_token: nil, invitation_accepted_at: Time.zone.now
      end
    end

    trait :agreement_accepted do
      registration_finished { true }
    end

    trait :old do
      employment_at { Faker::Date.between(from: 2.years.ago, to: 6.months.ago) }
    end
  end

  factory :admin, parent: :user do
    invite_accepted

    name { 'Admin' }
    surname { 'Dev' }
    email { 'admin@roonyx.tech' }
    roles { [create(:admin_role)] }
  end

  factory :deleted_user, parent: :user do
    deleted_at { Faker::Date.backward(days: 1) }
  end
end
