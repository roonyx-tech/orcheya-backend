require 'rails_helper'

RSpec.describe UpdateNotifier do
  subject { described_class.new(options) }
  let(:user) { create :user }
  let(:options) { { recipient: user } }

  context '#remind' do
    before do
      expect_any_instance_of(described_class).to receive(:post).with(user, kind_of(String)).and_call_original
    end

    it { UpdateNotifier.new(recipient: user, date: Date.current, attempt: 'first').remind }
    it { UpdateNotifier.new(recipient: user, date: Date.current, attempt: 'second').remind }
    it { UpdateNotifier.new(recipient: user, date: Date.current).remind }
  end
end
