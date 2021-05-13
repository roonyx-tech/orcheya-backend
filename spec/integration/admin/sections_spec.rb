require 'swagger_helper'

describe 'Admin - Sections API' do
  path '/api/admin/sections' do
    get 'Get faq sections' do
      tags 'Admin - Sections'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns list of sections' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        run_test!
      end

      response '401', 'Not authorized' do
        run_test!
      end
    end

    post 'Create section' do
      tags 'Admin - Sections'
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

      response '200', 'Section created' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:body) do
          {
            title: 'test_section'
          }
        end
        run_test! do |response|
          section = JSON.parse(response.body, symbolize_names: true)
          expect(section[:title]).to eq('test_section')
        end
      end

      response '422', 'Unprocessable entity' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:body) do
          {
            title: ''
          }
        end
        run_test!
      end

      response '401', 'needs to be signed in' do
        let(:logged_user) { nil }
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:error]).to eq('You need to sign in or sign up before continuing.')
        end
      end
    end
  end

  path '/api/admin/sections/{id}' do
    put 'Update section' do
      tags 'Admin - Sections'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

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

      response '200', 'Section updated' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:section) { create :section, title: 'test_section' }
        let(:id) { section.id }
        let(:body) do
          {
            title: 'updated_section'
          }
        end
        run_test! do |response|
          section = JSON.parse(response.body, symbolize_names: true)
          expect(section[:title]).to eq('updated_section')
        end
      end

      response '422', 'Unprocessable entity' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:section) { create :section, title: 'test_section' }
        let(:id) { section.id }
        let(:body) do
          {
            title: ''
          }
        end
        run_test!
      end

      response '401', 'needs to be signed in' do
        let(:section) { create :section, title: 'test_section' }
        let(:id) { section.id }
        let(:logged_user) { nil }
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:error]).to eq('You need to sign in or sign up before continuing.')
        end
      end
    end

    delete 'Delete section' do
      tags 'Admin - Sections'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      response '204', 'Achievement deleted' do
        let(:section) { create :section, title: 'test_section' }
        let(:id) { section.id }
        let(:logged_user) { create :user, permissions: { admin: :faq } }

        run_test!
      end

      response '403', 'No permission' do
        let(:section) { create :section, title: 'test_section' }
        let(:id) { section.id }
        let(:logged_user) { create :user }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:message]).to eq('You have no permission to perform this action.')
        end
      end
    end
  end
end
