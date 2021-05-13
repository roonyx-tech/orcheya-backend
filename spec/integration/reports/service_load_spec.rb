require 'swagger_helper'

describe 'Service Load' do
  path '/api/reports/service_load' do
    get 'Service Load' do
      tags 'Report ServiceLoad'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :start_date,
                in: :query,
                type: :string,
                description: 'start date',
                required: true

      parameter name: :end_date,
                in: :query,
                type: :string,
                description: 'end date',
                required: true

      parameter name: :step,
                in: :query,
                type: :string,
                description: 'step',
                required: true

      response '401', 'needs to be signed in' do
        let(:start_date) { '2018-01-01' }
        let(:end_date) { '2018-01-01' }
        let(:step) { 'week' }

        run_test!
      end

      response '200', 'return service load' do
        let(:logged_user) { create :user }

        let(:start_date) { '2018-01-01' }
        let(:end_date) { '2018-01-01' }
        let(:step) { 'week' }

        run_test!
      end
    end
  end
end
