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

require 'rails_helper'

RSpec.describe Worklog, type: :model do
  let(:user) { create :user }
  let(:project) { create :project }
  let!(:worklog) { create :worklog, user: user, project: project }

  it '#title' do
    expect(worklog.title).to eql("[#{worklog.project.name}] #{worklog.task_name}")
  end

  context 'default way' do
    it '#tracker' do
      expect(worklog.tracker).to eql(worklog.source.to_s.camelcase)
    end
  end

  context 'Trello way' do
    let!(:worklog) { create :worklog, user: user, project: project, task_url: 'https://trello.com/c/Uhds2sdh' }
    it '#tracker' do
      expect(worklog.tracker).to eql('Trello')
    end
  end

  context 'Jira way' do
    let!(:worklog) do
      create :worklog, user: user, project: project, task_url: 'https://roonyx.atlassian.net/browse/ORC-843'
    end
    it '#tracker' do
      expect(worklog.tracker).to eql('JIRA')
    end
  end
end
