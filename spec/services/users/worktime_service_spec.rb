require 'rails_helper'

RSpec.describe Users::WorktimeService do
  subject { described_class.new(user, options) }
  let(:user) { create :user, working_hours: 35, created_at: 1.month.ago, permissions: { projects: :timer } }
  let(:options) do
    {
      start_date: start_date,
      finish_date: finish_date
    }
  end
  let(:start_date) { Time.zone.today.beginning_of_week }
  let(:finish_date) { Time.zone.today.end_of_week }

  context '#working_days' do
    it 'should have 5 working days in a working week' do
      expect(subject.working_days_count).to eql 5
    end

    it 'should have 4 working days in a week with a holiday' do
      create :holiday_event, date: start_date
      expect(subject.working_days_count).to eql 4
    end
  end

  context '#working_time' do
    it 'should have 35 working hours in a working week' do
      expect(subject.working_time).to eql 35.hours
    end

    it 'should have 28 working hours in a week with a holiday' do
      create :holiday_event, date: start_date
      expect(subject.working_time).to eql 28.hours
      expect(subject.days_off).to match_array([start_date.to_date])
    end
  end

  context '#working_time_by_dates' do
    it 'should have 35 working hours in a working week' do
      expect(subject.working_time_by_dates.count).to eql 5
      summa = subject.working_time_by_dates.reduce(0) { |sum, x| sum + x[:time] }
      expect(summa).to eql 35.hours
    end

    it 'should have 28 working hours in a week with a holiday' do
      create :holiday_event, date: start_date
      expect(subject.working_time_by_dates.count).to eql 4
      summa = subject.working_time_by_dates.reduce(0) { |sum, x| sum + x[:time] }
      expect(summa).to eql 28.hours
    end
  end

  context '#vacation_days' do
    it('should have no vacations days') { expect(subject.vacation_days).to be_empty }
    it 'should have two vacations days' do
      create :vacation_event, user: user, status: :approved, started_at: Time.current, ended_at: 1.day.from_now
      expect(subject.vacation_days).to match_array([Date.current, 1.day.from_now.to_date])
      expect(subject.days_off).to match_array([Date.current, 1.day.from_now.to_date])
    end
  end

  context '#worked_hours' do
    let(:project) { create :project }

    it('should have 10 hours') do
      create :worklog, user: user, project: project, date: start_date, length: 10.hours
      expect(subject.worked_out).to eql 10.hours
    end

    it('#balance should be eql to -25 hours') do
      create :worklog, user: user, project: project, date: start_date, length: 10.hours
      expect(subject.balance).to eql(-25.hours)
    end
  end
end
