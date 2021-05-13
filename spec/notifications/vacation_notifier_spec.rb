require 'rails_helper'

RSpec.describe VacationNotifier do
  let(:vacation) { create :vacation_event, user: user, started_at: 1.day.ago, ended_at: 1.day.since, assignee: manager }
  let(:user) { create :user }
  let(:manager) { create :user, permissions: { calendar: :vacation } }

  it '#create' do
    expect_any_instance_of(described_class).to receive(:post).with(manager, kind_of(String)).and_call_original
    described_class.notify(:create, event: vacation)
  end

  it '#update' do
    expect_any_instance_of(described_class).to receive(:post).with(manager, kind_of(String)).and_call_original
    described_class.notify(:update, event: vacation)
  end

  it '#destroy' do
    expect_any_instance_of(described_class).to receive(:post).with(manager, kind_of(String)).and_call_original
    described_class.notify(:destroy, event: vacation)
  end

  it '#approve' do
    expect_any_instance_of(described_class).to receive(:post).with(user, kind_of(String)).and_call_original
    described_class.notify(:approve, event: vacation)
  end

  it '#disapprove' do
    expect_any_instance_of(described_class).to receive(:post).with(user, kind_of(String)).and_call_original
    described_class.notify(:disapprove, event: vacation)
  end

  it '#approve_vacation' do
    user = create :user
    vacation = create :vacation_event, user: user, started_at: Time.zone.today,
                                       ended_at: 10.days.since, status: :approved

    expect_any_instance_of(described_class).to receive(:post).and_call_original
    described_class.notify(:approve_vacation, vacation: vacation)
  end

  it '#without_vacation' do
    create :user, employment_at: 7.months.ago, vacation_notifier_disabled: false
    role = create :role, name: 'HR'
    create :user, roles: [role]

    expect_any_instance_of(described_class).to receive(:post).and_call_original
    described_class.notify(:without_vacations)
  end
end
