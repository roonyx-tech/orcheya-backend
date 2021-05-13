# == Schema Information
#
# Table name: events
#
#  id           :bigint(8)        not null, primary key
#  title        :string
#  description  :text
#  started_at   :datetime
#  ended_at     :datetime
#  all_day      :boolean
#  event_tag_id :bigint(8)
#  user_id      :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  deleted_at   :datetime
#  status       :integer          default("draft")
#  type         :string
#  project_id   :bigint(8)
#  assignee_id  :bigint(8)
#
# Indexes
#
#  index_events_on_assignee_id   (assignee_id)
#  index_events_on_deleted_at    (deleted_at)
#  index_events_on_event_tag_id  (event_tag_id)
#  index_events_on_project_id    (project_id)
#  index_events_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_id => users.id)
#  fk_rails_...  (project_id => projects.id)
#

class Event < ApplicationRecord
  acts_as_paranoid
  attribute :tag

  TYPES = {
    common: 'Events::Common',
    holiday: 'Events::Holiday',
    vacation: 'Events::Vacation',
    project: 'Events::Project'
  }.freeze

  belongs_to :user, optional: true
  belongs_to :assignee, optional: true, class_name: 'User'
  belongs_to :project, optional: true

  scope :overlap, ->(start_date, end_date) { where('ended_at >= ? AND started_at <= ?', start_date, end_date) }
  scope :at, ->(date) { where('ended_at > ? AND started_at < ?', date, date) }
  scope :at_date, ->(date) { where(started_at: date.beginning_of_day..date.end_of_day) }
  scope :between, ->(start_date, end_date) { where(started_at: start_date.beginning_of_day..end_date.end_of_day) }
  scope :not_canceled, -> { where.not(status: :canceled) }
  scope :dates, (lambda do
    map do |holiday|
      dt_start = holiday.started_at.to_date
      dt_end = holiday.ended_at.to_date
      dt_start == dt_end ? dt_start : (dt_start..dt_end).to_a
    end.flatten.compact.uniq
  end)

  validates :title, :started_at, :ended_at, presence: true
  validate :comparing_dates

  enum status: %i[draft canceled done approved]

  class << self
    def find_sti_class(type_name)
      TYPES[type_name.to_sym].constantize
    end

    def sti_name
      TYPES.invert[to_s]
    end
  end

  def serializable_hash(options = nil)
    super.merge type: type
  end

  def days
    (ended_at.to_date - started_at.to_date).to_i + 1
  end

  private

  def comparing_dates
    return if ended_at && started_at && ended_at >= started_at
    errors.add :ended_at, 'should be after start date'
  end
end
