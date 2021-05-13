require 'swagger_helper'

describe 'Projects API' do
  path '/api/projects' do
    get 'Get user projects' do
      tags 'Projects'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns list projects' do
        let(:logged_user) { create :user }
        run_test!
      end
    end

    post 'Create project' do
      tags 'Projects'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :body,
                in: :body,
                schema: {
                  type: :object,
                  properties:
                    {
                      title: {
                        type: :string,
                        example: 'title',
                        required: true
                      }
                    }
                }

      response '200', 'project created' do
        let(:logged_user) { create :user, permissions: { projects: :planning } }
        let(:body) do
          { title: 'project_sample' }
        end

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:name]).to eq('project_sample')
        end
      end

      response '422', 'unprocessable entity' do
        let(:logged_user) { create :user, permissions: { projects: :planning } }
        let(:body) do
          { title: '' }
        end

        run_test!
      end
    end
  end

  path '/api/projects/{id}' do
    put 'Update project' do
      tags 'Projects'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                description: 'project id',
                minimum: 1,
                required: true,
                example: 1

      parameter name: :body,
                in: :body,
                schema: {
                  type: :object,
                  properties:
                    {
                      title: {
                        type: :string,
                        example: 'title',
                        required: true
                      }
                    }
                }

      response '200', 'project updated' do
        let(:logged_user) { create :user, permissions: { projects: :planning } }
        let(:project) { create :project, platform: 'inner' }
        let(:id) { project.id }
        let(:body) do
          { title: 'project_sample' }
        end

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:title]).to eq('project_sample')
        end
      end

      response '422', 'unprocessable entity' do
        let(:logged_user) { create :user, permissions: { projects: :planning } }
        let(:project) { create :project, platform: 'inner' }
        let(:id) { project.id }
        let(:body) do
          { title: '' }
        end

        run_test!
      end
    end
  end
end
