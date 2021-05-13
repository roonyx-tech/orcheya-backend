require 'rails_helper'

RSpec.describe Integration::SlackController, type: :controller do
  describe 'POST slash' do
    it 'raises StandardError' do
      expect do
        post :slash
      end.to raise_error
    end
  end
end
