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
  class Holiday < ::Event
    before_validation :normalize
    after_save :refresh_overlapped_vacations
    after_destroy :refresh_overlapped_vacations

    class << self
      def generate(from_date = nil, to_date = nil)
        from_date ||= Date.current
        to_date ||= 2.years.from_now

        Holidays.between(from_date, to_date, :ru, :observed).each do |holiday|
          Events::Holiday.at_date(holiday[:date]).first_or_create!(
            started_at: holiday[:date],
            ended_at: holiday[:date],
            title: holiday[:name]
          )
        end
      end
    end

    private

    def refresh_overlapped_vacations
      Events::Vacation.overlap(started_at.to_date, ended_at.to_date).each(&:refresh_vacation_days_used!)
    end

    def normalize
      self.user_id = nil
      self.all_day = true
      self.started_at = started_at.try(:beginning_of_day)
      self.ended_at = ended_at.try(:end_of_day)
    end
  end
end
