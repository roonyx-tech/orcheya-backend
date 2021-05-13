require 'rails_helper'

RSpec.describe TimesheetReport do
  context '#report' do
    from = Time.zone.today - 1.year
    to =   Time.zone.today
    let!(:user) { create :user, permissions: { projects: :timer } }
    let(:project) { create :project }
    let(:project_paid) { create :project, paid: true }
    before do
      create :worklog, user: user, project: project, date: Time.zone.today
      create :worklog, user: user, project: project_paid, date: Time.zone.yesterday
    end

    it '.match report' do
      report = TimesheetReport.report(from, to, [user.id], [user.roles.first.id])
      expect(report).not_to be_nil
    end
  end

  context '#week_report' do
    previous_week = Time.zone.today - 1.week
    from = previous_week.beginning_of_week
    to = from + 4.days
    week = (from..to).to_a

    let(:project) { create :project, paid: true }
    let!(:user_not_enough) do
      user = create :user, permissions: { projects: %i[participant timer] }, created_at: from
      create :worklog, user: user, project: project, date: from, length: 7.hours.to_i
      user
    end

    let!(:user_min_worked) do
      user = create :user, permissions: { projects: %i[participant timer] }, created_at: from
      week.each do |day|
        create :worklog, user: user, project: project, date: day, length: 7.hours.to_i
      end
      user
    end

    let!(:user_35_but_not_enough) do
      user = create :user, permissions: { projects: %i[participant timer] }, created_at: from, working_hours: 40
      week.each do |day|
        create :worklog, user: user, project: project, date: day, length: 7.hours.to_i
      end
      user
    end

    let!(:user_max_worked) do
      user = create :user, permissions: { projects: %i[participant timer] }, created_at: from, working_hours: 40
      week.each do |day|
        create :worklog, user: user, project: project, date: day, length: 8.hours.to_i
      end
      user
    end

    let!(:report) { TimesheetReport.week_report(from, to) }

    it '.match week_report' do
      expect(report).not_to be_nil
      expect(report[:not_enough_users].count).to eq 2
      expect(report[:max_worked_users].count).to eq 1
      expect(report[:min_worked_count]).to eq 3
    end
  end
end
