require 'swagger_helper'

describe 'Timings' do
  path '/api/timings' do
    get 'index' do
      tags 'Timings'
      security [apiKey: []]
      produces 'application/json'

      response '200', 'success' do
        let(:logged_user) { create :user }
        before { create :timing }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:logged_user) { nil }
        before { create :timing }

        run_test!
      end
    end
  end
end
