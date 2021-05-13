require 'rails_helper'

RSpec.describe TimesheetUsersNotifier do
  subject { described_class.new }

  let(:project) { create :project }
  let(:user) { create :user, permissions: { projects: :participant } }
  let!(:pm) { create :user, permissions: { notifications: :pm_monday } }

  let(:project_event) do
    create :project_event,
           user: user,
           started_at: 1.week.ago.beginning_of_week,
           ended_at: 1.week.ago.end_of_week,
           project: project
  end

  describe '#pm_monday' do
    specify do
      expect_any_instance_of(described_class).to(
        receive(:post).with(pm, kind_of(String))
          .and_call_original
      )
      described_class.notify(:pm_monday)
    end
  end
end
