# == Schema Information
#
# Table name: worklogs
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  length     :integer
#  task_id    :integer
#  task_name  :string
#  task_url   :string
#  date       :date
#  source     :integer
#  project_id :integer          default(0), not null
#  deleted_at :datetime
#  source_id  :integer
#  start_time :datetime
#  end_time   :datetime
#
# Indexes
#
#  index_worklogs_on_deleted_at  (deleted_at)
#  index_worklogs_on_user_id     (user_id)
#

class Worklog < ApplicationRecord
  include Datable

  acts_as_paranoid

  belongs_to :user, -> { with_deleted }, inverse_of: :worklogs
  belongs_to :project

  validates :length, presence: true
  validates :source, presence: true
  validates :project_id, presence: true

  scope :timedoctors, -> { where source: :timedoctor }

  enum source: {
    timedoctor: 1
  }

  def title
    "[#{project.name}] #{task_name}"
  end

  def tracker
    return source.to_s.camelcase if task_url.blank?
    if task_url.start_with? 'https://trello.com'
      'Trello'
    elsif task_url.start_with? %r{https:\/\/[^\.]+\.atlassian\.net}
      'JIRA'
    else
      source.to_s.camelcase
    end
  end
end
