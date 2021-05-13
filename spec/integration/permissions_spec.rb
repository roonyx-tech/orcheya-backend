require 'swagger_helper'

describe 'Permissions' do
  path '/api/permissions' do
    get 'index' do
      tags 'Permissions'
      security [apiKey: []]
      produces 'application/json'

      response '401', 'unauthorized' do
        let(:logged_user) { nil }

        run_test!
      end

      response '200', 'success' do
        let(:logged_user) { create :admin }

        run_test!
      end
    end
  end
end
