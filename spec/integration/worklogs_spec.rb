require 'swagger_helper'

describe 'Worklogs API' do
  path '/api/worklogs' do
    get 'worklogs index' do
      tags 'Session'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'get worklogs index' do
        let(:logged_user) { create :user }
        let(:project) { create :project }
        let!(:worklog) { create :worklog, project: project, user: logged_user, date: Date.current }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.count).to eq 1
        end
      end
    end
  end
end
