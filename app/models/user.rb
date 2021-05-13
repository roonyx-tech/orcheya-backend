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

class User < ApplicationRecord
  include Filterable
  include Devise::JWT::RevocationStrategies::JTIMatcher

  acts_as_paranoid

  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :trackable, :validatable,
         :invitable, :recoverable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum sex: { male: 1, female: 2 }

  belongs_to :timing, required: false
  has_one :onboarding, dependent: :destroy
  accepts_nested_attributes_for :onboarding

  has_many :updates, dependent: :destroy
  has_many :commits, dependent: :destroy
  has_many :worklogs, -> { with_deleted }, inverse_of: :user, dependent: :destroy
  has_many :roles_users, -> { with_deleted }, inverse_of: :user, dependent: :destroy
  has_many :roles, -> { distinct }, through: :roles_users
  has_many :permissions, -> { distinct }, through: :roles
  has_many :notifications, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :users_skills, dependent: :destroy
  has_many :skills, through: :users_skills
  has_many :vacations, class_name: 'Events::Vacation', inverse_of: :user, dependent: :destroy
  has_many :projects, -> { distinct }, through: :events
  has_many :users_achievements, dependent: :destroy
  has_many :achievements, through: :users_achievements

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :surname, presence: true
  validates :slack_id, uniqueness: true, allow_blank: true
  validates :english_level, numericality: { less_than_or_equal_to: 7 }
  validates :about, length: { maximum: 400 }

  before_validation :set_random_password, on: :create
  before_update :set_english_update_date
  before_destroy :nullify_timing

  scope :search_by_name, lambda { |search|
    where('(users.name || \' \' || users.surname) ILIKE :s', s: "%#{search}%")
  }
  scope :slack_connected?, -> { where.not(slack_id: nil, slack_token: nil) }
  scope :discord_connected?, lambda {
    where.not(discord_id: nil, discord_token: nil, discord_dm_id: nil)
  }
  scope :for_report, lambda { |start_date, stop_date|
    with_deleted
      .where(
        'users.created_at <= ? and (users.deleted_at is null or users.deleted_at >= ?)',
        stop_date,
        start_date
      )
  }

  scope :at_date, lambda { |date|
    with_deleted
      .where(
        '(employment_at < ? or (invitation_accepted_at < ? AND employment_at IS NULL))
         and (users.deleted_at is null or users.deleted_at >= ?)',
        date, date, date
      )
  }

  def full_name
    "#{name} #{surname}"
  end

  def discord_connected?
    discord_id.present? && discord_token.present? && discord_dm_id.present?
  end

  def slack_connected?
    slack_id.present? && slack_token.present?
  end

  def timedoctor_connected?
    timedoctor_token.present? &&
      timedoctor_refresh_token.present? &&
      timedoctor_company_id.present? &&
      timedoctor_user_id.present?
  end

  def available_vacations_days
    return 0 if new_record?

    days = (Time.zone.yesterday - (employment_at || created_at).to_date).to_i
    @available_vacations_days ||= (days * 0.07671 - vacation_days_used).to_f.ceil + vacation_days_initial
  end

  def new_vacation_days=(value)
    return if value.nil?

    self.vacation_days_initial = value
  end

  private

  def set_random_password
    self.password = SecureRandom.hex(8)
  end

  def set_english_update_date
    self.last_english_update = Time.zone.now.to_date if will_save_change_to_english_level?
  end

  def nullify_timing
    update(timing_id: nil)
  end
end
