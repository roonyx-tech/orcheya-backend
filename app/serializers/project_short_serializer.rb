# == Schema Information
#
# Table name: projects
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer
#  paid       :boolean          default(FALSE), not null
#  platform   :integer
#  manager_id :bigint(8)
#  archived   :boolean          default(FALSE), not null
#  title      :string
#
# Indexes
#
#  index_projects_on_manager_id  (manager_id)
#  index_projects_on_project_id  (project_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (manager_id => users.id)
#

class ProjectShortSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :paid, :platform

  def title
    object.title || object.name
  end
end
