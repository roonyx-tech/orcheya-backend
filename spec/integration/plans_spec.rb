require 'swagger_helper'

describe 'Plans API' do
  path '/api/plans/people' do
    get 'people' do
      tags 'Project people'
      security [apiKey: []]
      produces 'application/json'

      response '401', 'needs to be signed in' do
        run_test!
      end

      response '200', 'returns people' do
        let(:logged_user) { create :user, permissions: { projects: :planning } }
        let!(:user) { create :user, :invite_accepted, permissions: { projects: :participant } }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data.count).to eq(1)
        end
      end
    end
  end

  path '/api/plans/managers' do
    get 'managers' do
      tags 'Project managers'
      security [apiKey: []]
      produces 'application/json'

      response '401', 'needs to be signed in' do
        run_test!
      end

      response '200', 'returns project managers' do
        let(:logged_user) { create :user, permissions: { projects: :planning } }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data.count).to eq(1)
        end
      end
    end
  end

  path '/api/plans/projects' do
    get 'projects' do
      tags 'Projects for planning'
      security [apiKey: []]
      produces 'application/json'

      response '401', 'needs to be signed in' do
        run_test!
      end

      response '200', 'returns projects' do
        let(:logged_user) { create :user, permissions: { projects: :planning } }
        before { create :project, platform: :inner }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data.count).to eq(1)
        end
      end
    end
  end
end
