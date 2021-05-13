# == Schema Information
#
# Table name: worklogs
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  length     :integer
#  task_id    :integer
#  task_name  :string
#  task_url   :string
#  date       :date
#  source     :integer
#  project_id :integer          default(0), not null
#  deleted_at :datetime
#  source_id  :integer
#  start_time :datetime
#  end_time   :datetime
#
# Indexes
#
#  index_worklogs_on_deleted_at  (deleted_at)
#  index_worklogs_on_user_id     (user_id)
#

FactoryBot.define do
  factory :worklog do
    user { User.random }
    project { Project.random }
    sequence(:task_id) { |n| n }
    length { Faker::Number.between(from: 8000, to: 9000) }
    task_name { "task_name_#{task_id}" }
    task_url { "https://task_url/TASK-#{task_id}" }
    date { Faker::Date.between(from: 7.days.ago, to: Time.zone.today) }
    source { 1 }
  end

  factory :demo_worklog, parent: :worklog do
    project { Project.random }
    sequence(:task_id) { |n| n }
    task_name { "task_name_#{task_id}" }
    length { Faker::Number.between(from: 3600, to: 36_000) }
    task_url { "https://task_url/TASK-#{task_id}" }
    source { 1 }
  end
end
