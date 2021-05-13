require 'swagger_helper'

describe 'Admin - Answers API' do
  path '/api/admin/answers' do
    get 'Get faq answers' do
      tags 'Admin - Answers'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns list of answers' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        run_test!
      end

      response '401', 'Not authorized' do
        run_test!
      end
    end

    post 'Create answer' do
      tags 'Admin - Answers'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :body,
                in: :body,
                schema: {
                  type: :object,
                  properties:
                    {
                      content: {
                        type: :string,
                        example: 'content',
                        required: true
                      },
                      question_id: {
                        type: :integer,
                        example: 1,
                        required: true
                      }
                    }
                }

      response '200', 'Answer created' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:section) { create :section, title: 'test_section' }
        let(:question) { create :question, title: 'test_question', section: section }
        let(:body) do
          {
            content: 'test_answer',
            question_id: question.id
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          answer = data[:answer]
          expect(answer[:content]).to eq('test_answer')
        end
      end

      response '422', 'Unprocessable entity' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:section) { create :section, title: 'test_section' }
        let(:question) { create :question, title: 'test_question', section: section }
        let(:body) do
          {
            content: '',
            question_id: question.id
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

  path '/api/admin/answers/{id}' do
    put 'Update answer' do
      tags 'Admin - Answers'
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
                          content: {
                            type: :string,
                            example: 'content',
                            required: true
                          },
                          question_id: {
                            type: :integer,
                            example: 1,
                            required: true
                          }
                        }
                }

      response '200', 'Answer updated' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:section) { create :section, title: 'test_section' }
        let(:question) { create :question, title: 'test_question', section: section }
        let(:answer) { create :answer, content: 'test_answer', question: question }
        let(:id) { answer.id }
        let(:body) do
          {
            content: 'updated_answer',
            question_id: question.id
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          answer = data[:answer]
          expect(answer[:content]).to eq('updated_answer')
        end
      end

      response '422', 'Unprocessable entity' do
        let(:logged_user) { create :user, permissions: { admin: :faq } }
        let(:section) { create :section, title: 'test_section' }
        let(:question) { create :question, title: 'test_question', section: section }
        let(:answer) { create :answer, content: 'test_answer', question: question }
        let(:id) { answer.id }
        let(:body) do
          {
            content: '',
            question_id: nil
          }
        end
        run_test!
      end

      response '401', 'needs to be signed in' do
        let(:section) { create :section, title: 'test_section' }
        let(:question) { create :question, title: 'test_question', section: section }
        let(:answer) { create :answer, content: 'test_answer', question: question }
        let(:id) { answer.id }
        let(:logged_user) { nil }
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:error]).to eq('You need to sign in or sign up before continuing.')
        end
      end
    end

    delete 'Delete answer' do
      tags 'Admin - Answers'
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
        let(:answer) { create :answer, content: 'test_answer', question: question }
        let(:id) { answer.id }
        let(:logged_user) { create :user, permissions: { admin: :faq } }

        run_test!
      end

      response '403', 'No permission' do
        let(:section) { create :section, title: 'test_section' }
        let(:question) { create :question, title: 'test_question', section: section }
        let(:answer) { create :answer, content: 'test_answer', question: question }
        let(:id) { answer.id }
        let(:logged_user) { create :user }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:message]).to eq('You have no permission to perform this action.')
        end
      end
    end
  end
end
