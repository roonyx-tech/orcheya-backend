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

class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :started_at, :ended_at, :all_day, :type,
             :user_id, :project_id, :status
  belongs_to :user, serializer: UserShortInfoSerializer
  belongs_to :assignee, serializer: UserShortInfoSerializer
  belongs_to :project, serializer: ProjectShortSerializer
end
