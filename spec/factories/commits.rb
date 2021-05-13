# == Schema Information
#
# Table name: commits
#
#  id           :bigint(8)        not null, primary key
#  message      :string
#  uid          :string
#  time         :datetime
#  url          :string
#  user_id      :bigint(8)
#  project_name :string
#  project_id   :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_commits_on_project_id  (project_id)
#  index_commits_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :commit do
    message { 'MyString' }
    uid { 'MyString' }
    time { Time.zone.now }
    url { 'MyString' }
    user { User.random }
    project_name { 'MyString' }
    project { Project.random }
  end
end
