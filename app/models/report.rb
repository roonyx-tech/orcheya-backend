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

class Report < ApplicationRecord
  belongs_to :project

  validates :text, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validate :comparing_dates

  private

  def comparing_dates
    return if ended_at && started_at && ended_at >= started_at
    errors.add :ended_at, 'You cannot save an report for that date.'
  end
end
