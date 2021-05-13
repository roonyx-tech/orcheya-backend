require 'swagger_helper'

describe 'Admin - Questions API' do
  path '/api/admin/questions' do
    get 'Get faq questions' do
      tags 'Admin - Questions'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns list of questions' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        run_test!
      end

      response '401', 'Not authorized' do
        run_test!
      end
    end

    post 'Create question' do
      tags 'Admin - Questions'
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
                      },
                      section_id: {
                        type: :integer,
                        example: 1,
                        required: true
                      }
                    }
                }

      response '200', 'Question created' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:section) { create :section, title: 'test_section' }
        let(:body) do
          {
            title: 'test_question',
            section_id: section.id
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          question = data[:question]
          expect(question[:title]).to eq('test_question')
        end
      end

      response '422', 'Unprocessable entity' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:section) { create :section, title: 'test_section' }
        let(:body) do
          {
            title: '',
            section_id: section.id
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

  path '/api/admin/questions/{id}' do
    put 'Update question' do
      tags 'Admin - Questions'
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
                      },
                      section_id: {
                        type: :integer,
                        example: 1,
                        required: true
                      }
                    }
                }

      response '200', 'Question updated' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:section) { create :section, title: 'test_section' }
        let(:question) { create :question, title: 'test_question', section: section }
        let(:id) { question.id }
        let(:body) do
          {
            title: 'updated_question',
            section_id: section.id
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          question = data[:question]
          expect(question[:title]).to eq('updated_question')
        end
      end

      response '422', 'Unprocessable entity' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:section) { create :section, title: 'test_section' }
        let(:question) { create :question, title: 'test_question', section: section }
        let(:id) { question.id }
        let(:body) do
          {
            title: '',
            section_id: nil
          }
        end
        run_test!
      end

      response '401', 'needs to be signed in' do
        let(:section) { create :section, title: 'test_section' }
        let(:question) { create :question, title: 'test_question', section: section }
        let(:id) { question.id }
        let(:logged_user) { nil }
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:error]).to eq('You need to sign in or sign up before continuing.')
        end
      end
    end

    delete 'Delete question' do
      tags 'Admin - Questions'
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
        let(:question) { create :question, title: 'test_question', section: section }
        let(:id) { question.id }
        let(:logged_user) { create :user, permissions: { admin: :faq } }

        run_test!
      end

      response '403', 'No permission' do
        let(:section) { create :section, title: 'test_section' }
        let(:question) { create :question, title: 'test_question', section: section }
        let(:id) { question.id }
        let(:logged_user) { create :user }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:message]).to eq('You have no permission to perform this action.')
        end
      end
    end
  end
end
