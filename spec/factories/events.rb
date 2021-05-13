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

FactoryBot.define do
  TITLE = ['FullStack Developer', 'Backend Developer', 'Frontend Developer', 'Manager', 'PM', 'HR', 'QA',
           'AI Developer', 'Sales', 'DevOps', 'Mobile Developer', 'Mentor', 'Lead Generation'].freeze
  factory :event do
    title { TITLE.sample }
    type { 'common' }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    all_day { Faker::Boolean.boolean }
    user { User.random }

    before(:create) do |user|
      date = [
        Faker::Time.between(from: Time.current - 1.month, to: Time.current + 3.weeks),
        Faker::Time.between(from: Time.current - 1.month, to: Time.current + 3.weeks)
      ]
      user.started_at ||= date.min
      user.ended_at ||= date.max
    end

    factory :common_event do
      type { 'common' }
    end

    factory :holiday_event, class: 'Events::Holiday' do
      type { 'holiday' }
      transient do
        date { Time.zone.today }
      end
      started_at { date.beginning_of_day }
      ended_at { date.end_of_day }
    end

    factory :project_event, class: 'Events::Project' do
      type { 'project' }
      project { Project.random }
    end

    factory :vacation_event, class: 'Events::Vacation' do
      type { 'vacation' }
    end

    factory :vacation_event_approved, class: 'Events::Vacation' do
      type { 'vacation' }
      status { 'approved' }
    end
  end
end
