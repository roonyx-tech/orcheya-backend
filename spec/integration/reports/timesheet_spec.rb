require 'swagger_helper'

describe 'Timesheet' do
  path '/api/reports/timesheet' do
    get 'Timesheet' do
      tags 'Report Timesheet'
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

      parameter name: :users_ids,
                in: :query,
                type: :string,
                description: 'users ids are split by comma',
                required: false

      parameter name: :roles_ids,
                in: :query,
                type: :string,
                description: 'roles ids are split by comma',
                required: false

      response '200', 'return timesheet' do
        let(:logged_user) { create :user }
        let(:start_date) { '2018-01-01' }
        let(:end_date) { '2018-01-01' }

        run_test!
      end
    end
  end
end
