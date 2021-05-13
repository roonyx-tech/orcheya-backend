require 'rails_helper'

RSpec.describe TimedoctorNotifier do
  subject { described_class.new(options) }
  let(:user) { create :user }
  let(:options) { { recipient: user } }

  it '#broken' do
    expect_any_instance_of(described_class).to receive(:post).with(user, kind_of(String)).and_call_original
    subject.broken
  end
end
