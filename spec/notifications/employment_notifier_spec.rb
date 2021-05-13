require 'rails_helper'

RSpec.describe EmploymentNotifier do
  subject { described_class.new }

  context '#congratulate_employment' do
    it 'should not congratulate_employment' do
      create :user, employment_at: 1.day.ago
      create :user, employment_at: 1.day.ago
      expect_any_instance_of(described_class).to_not receive(:post).and_call_original
      described_class.notify(:congratulate_employment)
    end

    it 'should congratulate_employment' do
      create :user, employment_at: Date.current
      create :user, employment_at: Date.current
      create :user, employment_at: 1.day.ago
      expect_any_instance_of(described_class).to receive(:post).twice.and_call_original
      described_class.notify(:congratulate_employment)
    end
  end

  it 'should not remind_employment' do
    create :user, employment_at: 1.day.ago - 1.year
    create :user, employment_at: 7.days.since - 1.year
    expect_any_instance_of(described_class).to receive(:post).and_call_original
    described_class.notify(:remind_employment)
  end

  it 'does not users_on' do
    expect(subject.send(:users_on, Date.current)).to eq([])
  end

  it '#all' do
    expect_any_instance_of(described_class).to receive(:congratulate_employment).and_call_original
    expect_any_instance_of(described_class).to receive(:remind_employment).and_call_original
    described_class.notify(:all)
  end
end
