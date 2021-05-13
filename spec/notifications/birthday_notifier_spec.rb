require 'rails_helper'

RSpec.describe BirthdayNotifier do
  subject { described_class.new }

  context '#congratulate' do
    it 'should not congratulate' do
      create :user, birthday: 1.day.ago
      create :user, birthday: 1.day.ago
      expect_any_instance_of(described_class).to_not receive(:post).and_call_original
      described_class.notify(:congratulate)
    end

    it 'should congratulate' do
      create :user, birthday: Date.current
      create :user, birthday: Date.current
      create :user, birthday: 1.day.ago
      expect_any_instance_of(described_class).to receive(:post).twice.and_call_original
      described_class.notify(:congratulate)
    end
  end

  it '#remind' do
    create :user, birthday: 1.day.ago - 1.year
    create :user, birthday: 3.days.since - 1.year
    create :user, birthday: 7.days.since - 1.year
    expect_any_instance_of(described_class).to receive(:post).and_call_original
    described_class.notify(:remind)
  end

  it '#all' do
    expect_any_instance_of(described_class).to receive(:remind).and_call_original
    expect_any_instance_of(described_class).to receive(:congratulate).and_call_original
    described_class.notify(:all)
  end
end
