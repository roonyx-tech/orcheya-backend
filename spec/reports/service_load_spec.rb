require 'rails_helper'

RSpec.describe ServiceLoadReport do
  subject { ServiceLoadReport.report(from, to, unit) }
  let(:user) { create :user, permissions: { projects: :timer }, created_at: from }
  let(:project) { create :project, paid: true }
  let(:project2) { create :project, paid: false }
  let(:from) { Time.zone.today - 1.year }
  let(:to) { Time.zone.today }
  let(:unit) { 'week' }

  it '#report' do
    create :worklog, user: user, project: project, date: from, length: 10.hours

    expect(subject).not_to be_nil
    expect(subject).to include(:dash, :users_table, :projects_table, :dates, :load_table)

    expect(subject[:dates]).to be_a(Array)
    expect(subject[:load_table]).to be_a(Array)
    expect(subject[:dash]).to be_a(Hash)
    expect(subject[:users_table]).to be_a(Array)
    expect(subject[:users_table]).not_to be_empty
    expect(subject[:projects_table]).to be_a(Array)

    expect(subject[:dash]).to include :workdays,
                                      :developers,
                                      :other,
                                      :hours,
                                      :worked_hours,
                                      :paid_hours,
                                      :total_paid,
                                      :active_projects,
                                      :paid_projects
  end

  context 'month' do
    let(:unit) { 'month' }
    it '#report' do
      create :worklog, user: user, project: project, date: from, length: 10.hours

      expect(subject).not_to be_nil
    end
  end
end
