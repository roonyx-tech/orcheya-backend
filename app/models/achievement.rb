# == Schema Information
#
# Table name: achievements
#
#  id         :bigint(8)        not null, primary key
#  title      :string           not null
#  kind       :integer
#  image      :string
#  endpoint   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Achievement < ApplicationRecord
  mount_base64_uploader :image, ImageUploader

  validates :title, presence: true
  has_many :users_achievements, dependent: :destroy
  has_many :users, through: :users_achievements
  has_many :achievements_roles, dependent: :destroy
  has_many :levels, class_name: 'AchievementLevel', dependent: :destroy, index_errors: true
  has_many :roles, through: :achievements_roles, after_add: :add_user_achievements, after_remove: :remove_users

  accepts_nested_attributes_for :levels, allow_destroy: true
  validates_associated :levels

  KINDS = %i[manual auto].freeze
  enum kind: KINDS

  after_create :add_user_achievements

  private

  def add_user_achievements(role = false)
    return unless auto? && role.present?
    (role.users - users).each do |user|
      users << user unless users.include?(user)
    end
  end

  def remove_users(role = false)
    return unless auto?
    (role.users - roles.map(&:users).flatten).each do |user|
      users.delete(user)
    end
  end
end
