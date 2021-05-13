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

class ReportSerializer < ActiveModel::Serializer
  attributes :id,
             :text,
             :project_id,
             :started_at,
             :ended_at

  belongs_to :project
end
