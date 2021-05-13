# == Schema Information
#
# Table name: update_projects
#
#  id         :bigint(8)        not null, primary key
#  update_id  :bigint(8)
#  project_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#
# Indexes
#
#  index_update_projects_on_deleted_at  (deleted_at)
#  index_update_projects_on_project_id  (project_id)
#  index_update_projects_on_update_id   (update_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (update_id => updates.id)
#

class UpdateProject < ApplicationRecord
  acts_as_paranoid

  belongs_to :slack_update,
             foreign_key: 'update_id',
             class_name: 'Update',
             inverse_of: :update_projects

  belongs_to :project
end
