require 'swagger_helper'

describe 'Skills Types API' do
  path '/api/skill_types' do
    get 'index' do
      tags 'Skills Types'
      security [apiKey: []]
      produces 'application/json'

      response '200', 'returns list of skill types' do
        let(:logged_user) { create :user }

        run_test!
      end
    end
  end
end
