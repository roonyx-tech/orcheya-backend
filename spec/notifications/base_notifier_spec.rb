require 'rails_helper'

RSpec::Matchers.define :path_ends_with do |path|
  match { |actual| actual.to_s.ends_with?(path) }
end

RSpec.describe BaseNotifier do
  subject { BaseNotifier.new(options) }
  let(:user) { build :user }
  let(:options) { { recipient: user } }

  it '#render_message' do
    allow(File).to receive(:read).and_return 'test_<%= recipient.name %>'
    expect(File).to receive(:read).with(path_ends_with('/app/views/notifications/base/test.erb'))
    expect(subject.render_message(:test)).to eql "test_#{user.name}"
  end

  it '#link' do
    Rails.application.credentials.frontend_url = 'https://domain'
    expect(subject.link('test')).to eql 'https://domain/test'
  end

  it '#notify' do
    allow(File).to receive(:read).and_return 'test'
    expect(subject).to receive(:post).with(user, kind_of(String)).and_return true
    subject.notify
  end

  it '#post' do
    expect(DiscordPostMessageJob).to receive(:perform_later).with(user, 'test').and_return true
    subject.post(user, 'test')
  end
end
