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

module Events
  class Vacation < ::Event
    validates :user, presence: true
    validates :description, presence: true, if: :canceling?

    validate :not_earlier_than_today, on: :personal_submission
    validate :check_overlap

    before_validation :normalize
    after_save :refresh_vacation_days_used!
    before_update :notify_vacation_approve
    after_destroy :refresh_vacation_days_used!

    def refresh_vacation_days_used!
      days_used = 0
      holidays_overlap = 0
      user.vacations.approved.each do |vacation|
        holidays = Events::Holiday.overlap(vacation.started_at.to_date, vacation.ended_at.to_date)
        holidays.each do |holiday|
          overlap_start = [vacation.started_at.to_date, holiday.started_at.to_date].max
          overlap_end = [vacation.ended_at.to_date, holiday.ended_at.to_date].min
          overlap_days = (overlap_end - overlap_start).to_i + 1
          holidays_overlap += overlap_days
        end
        days_used += ((vacation.ended_at.end_of_day - vacation.started_at.beginning_of_day) / 86_400).round.to_i
      end
      days_used -= holidays_overlap
      user.update!(vacation_days_used: days_used)
    end

    private

    def canceling?
      canceled? && status_changed?
    end

    def normalize
      self.all_day = true
      self.title = "Vacation #{started_at.to_date} - #{ended_at.to_date}"
    end

    def notify_vacation_approve
      VacationNotifier.notify(:approve_vacation, vacation: self) if status_changed? && status == 'approved'
    end

    def not_earlier_than_today
      return if started_at > Time.zone.yesterday
      errors.add :started_at, 'Vacations can begin no earlier than today'
    end

    def check_overlap
      vacations = user.vacations.not_canceled.overlap(started_at.to_date, ended_at.to_date)
      vacations = vacations.where.not(id: id) if id.present?
      return if vacations.empty?

      errors.add :started_at, 'Vacation overlap with another'
    end
  end
end
