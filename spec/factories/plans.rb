# == Schema Information
#
# Table name: plans
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  manager_id :bigint(8)
#  project_id :bigint(8)
#  status     :integer
#  start      :date
#  finish     :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_plans_on_manager_id  (manager_id)
#  index_plans_on_project_id  (project_id)
#  index_plans_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (manager_id => users.id)
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :plan do
    status { Plan.statuses.key.sample }
    project { Project.random }
    user { User.random }
    manager { User.random }
    sequence(:start) { |i| Time.zone.today - 2.months + i.weeks - 3.days }
    sequence(:finish) { |i| Time.zone.today - 2.months + i.weeks + 2.days }
  end
end
