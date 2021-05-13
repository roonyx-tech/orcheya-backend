require 'rails_helper'

RSpec.describe TrackEventsController, type: :controller do
  describe 'GET #create' do
    let(:logged_user) { create :user }

    it 'returns http success' do
      sign_in(logged_user)
      get :create, params: { e: 'test' }
      expect(response).to have_http_status(:success)
    end
  end
end
