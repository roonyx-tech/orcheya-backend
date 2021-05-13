require 'rails_helper'

RSpec.describe HolidayNotifier do
  subject { described_class.new }

  before do
    @date = '11-06-2020'.to_date
    allow(Time).to receive(:zone).and_return @timezone
    @timezone.stub(:now).and_return(@date.to_datetime)
    @timezone.stub(:today).and_return(@date)
    @timezone.stub(:tomorrow).and_return(@date + 1.day)
  end

  context '#day_before' do
    it 'should send notifications' do
      tomorrow = Time.zone.tomorrow
      create :user, :invite_accepted
      create :event, started_at: tomorrow, ended_at: tomorrow, type: 'holiday'
      create :event, started_at: tomorrow + 1.day, ended_at: tomorrow + 1.day, type: 'holiday'
      expect_any_instance_of(described_class).to receive(:post).and_call_original
      described_class.notify(:day_before)
    end
  end

  context '#week_before' do
    it 'should send notifications' do
      next_week = Time.zone.today + 1.week
      create :event, started_at: next_week, ended_at: next_week, type: 'holiday'
      expect_any_instance_of(described_class).to receive(:post).and_call_original
      described_class.notify(:week_before)
    end
  end
end
