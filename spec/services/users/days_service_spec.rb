require 'rails_helper'

RSpec.describe Users::DaysService do
  subject { described_class.new(user, start_date, finish_date) }
  let(:user) { create :user, working_hours: 35, created_at: 1.month.ago, permissions: { projects: :timer } }
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

  context '#vacation_days' do
    it('should have no vacations days') { expect(subject.vacation_days).to be_empty }
    it 'should have two vacations days' do
      create :vacation_event, user: user, status: :approved, started_at: Time.current, ended_at: 1.day.from_now
      expect(subject.vacation_days).to match_array([Date.current, 1.day.from_now.to_date])
      expect(subject.days_off).to match_array([Date.current, 1.day.from_now.to_date])
    end
  end

  context '#workday' do
    let(:today) { 1.month.ago + 1.day }
    before do
      allow(Time.zone).to receive(:today) { today }
    end

    it 'should return true' do
      expect(described_class.workday?(user)).to eql true
    end

    it 'on vacation should return false' do
      create :vacation_event, user: user, status: :approved, started_at: today, ended_at: today
      expect(described_class.workday?(user)).to eql false
    end

    it 'on vacation should return false' do
      create :holiday_event, date: today
      expect(described_class.workday?(user)).to eql false
    end
  end
end
