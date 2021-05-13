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

class Commit < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true
end
