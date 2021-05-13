require 'rails_helper'

RSpec.describe TokenService, type: :request do
  subject { TokenService.instance }
  let(:user) { create :user }
  let!(:valid_token) { subject.find_or_generate(user) }

  before(:each) { subject.clear }

  it '#generate' do
    expect(subject.tokens).to be_empty
    expect(subject.generate(user)).to_not be_blank
  end

  it '#find_valid' do
    expect(subject.find_valid(user)).to be_nil
    subject.generate(user)
    expect(subject.find_valid(user)).to_not be_blank
  end
end
