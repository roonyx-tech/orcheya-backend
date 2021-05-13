# == Schema Information
#
# Table name: notifications
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  text       :string           not null
#  importance :integer          default("medium"), not null
#  readed_at  :datetime
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_notifications_on_deleted_at  (deleted_at)
#  index_notifications_on_user_id     (user_id)
#

class Notification < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  default_scope { where(readed_at: nil).order(created_at: :desc) }

  validates :text, presence: true
  validates :importance, presence: true

  enum importance: {
    low: 1,
    medium: 2,
    hight: 3,
    critical: 4
  }
end
