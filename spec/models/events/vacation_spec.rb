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

require 'rails_helper'

RSpec.describe Events::Vacation, type: :model do
  let(:user) { create :user }
  let(:vacation) { build :vacation_event, user: user }

  it '#not_earlier_than_a_month' do
    vacation.started_at = Time.zone.yesterday
    vacation.ended_at = 10.days.since
    vacation.valid?(:personal_submission)
    expect(vacation.errors[:started_at]).to include('Vacations can begin no earlier than today')
  end

  context 'overlapped vacations' do
    let!(:vacation_overlap) { create :vacation_event, user: user, started_at: Time.zone.today, ended_at: 8.days.since }

    it '#check_overlap' do
      vacation.started_at = Time.zone.today
      vacation.ended_at = 10.days.since
      vacation.valid?(:personal_submission)
      expect(vacation.errors[:started_at]).to include('Vacation overlap with another')
    end
  end
end
