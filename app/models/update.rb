# == Schema Information
#
# Table name: updates
#
#  id                 :bigint(8)        not null, primary key
#  date               :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  made               :string
#  planning           :string
#  issues             :string
#  user_id            :integer
#  deleted_at         :datetime
#  slack_ts           :string
#  discord_message_id :string
#
# Indexes
#
#  index_updates_on_deleted_at        (deleted_at)
#  index_updates_on_user_id_and_date  (user_id,date) UNIQUE
#

class Update < ApplicationRecord
  acts_as_paranoid
  include Filterable
  include Datable

  belongs_to :user, -> { with_deleted }, inverse_of: :updates
  has_many :update_projects, dependent: :destroy
  has_many :projects, through: :update_projects

  validates :user, :date, :made, :planning, :issues, presence: true
  validates :date, uniqueness: { scope: :user }
  validate :date_cover

  scope :query, (lambda do |query|
    where('made like :query or planning like :query or issues like :query',
          query: "%#{query}%")
  end)

  scope :user_ids, ->(user_ids) { where user_id: user_ids }
  scope :project_ids, lambda { |project_ids|
    joins(update_projects: :project).where(projects: { id: project_ids })
  }
  scope :start_date, ->(date) { where 'date >= ?', date.to_date.beginning_of_day }
  scope :end_date, ->(date) { where 'date <= ?', date.to_date.end_of_day }
  scope :at_date, ->(date) { where(date: date.to_date.beginning_of_day..date.to_date.end_of_day) }

  private

  def date_cover
    validated = date&.to_date
    return if validated.blank? || ((Date.current - 1.day)..Date.current).cover?(validated)
    errors.add :date, 'You cannot save an update for that date.'
  end
end
