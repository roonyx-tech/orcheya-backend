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

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { create :project }

  context 'searchable' do
    it '#search_by' do
      expect(Project.search_by(%w[name], project.name)).to include(project)
    end
  end
end
