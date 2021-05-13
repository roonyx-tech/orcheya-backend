# == Schema Information
#
# Table name: reports
#
#  id         :bigint(8)        not null, primary key
#  text       :string           not null
#  project_id :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  started_at :datetime
#  ended_at   :datetime
#
# Indexes
#
#  index_reports_on_project_id  (project_id)
#

FactoryBot.define do
  factory :report do
    text { Faker::Lorem.paragraph }
    project { Project.random }
    before(:create) do |report|
      date = [
        Faker::Time.between(from: Time.current - 1.month, to: Time.current + 3.weeks),
        Faker::Time.between(from: Time.current - 1.month, to: Time.current + 3.weeks)
      ]
      report.started_at = date.min
      report.ended_at = date.max
    end
  end
end
