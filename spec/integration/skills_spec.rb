require 'swagger_helper'

describe 'Skills API' do
  path '/api/skills' do
    get 'Get user skills' do
      tags 'Skills'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns list skills' do
        let(:logged_user) { create :user }
        run_test!
      end
    end

    post 'Create user skill' do
      tags 'Admin - Skills'
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
                      difficulty_level_id: {
                        type: :bigint,
                        example: 1,
                        required: true
                      },
                      variants: {
                        type: :text,
                        example: 'text',
                        required: true
                      }
                    }
                }

      response '200', 'Skill created' do
        let(:logged_user) { create :user }
        let(:body) do
          {
            difficulty_level_id: '2',
            title: 'test',
            variants: 'test'
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          skill = data[:skill]
          expect(skill[:title]).to eq('test')
        end
      end

      response '401', 'needs to be signed in' do
        let(:logged_user) { nil }
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:error]).to eq('You need to sign in or sign up before continuing.')
        end
      end

      response '422', 'failure' do
        let(:logged_user) { create :user }
        let(:body) do
          {
            difficulty_level_id: '2',
            title: nil,
            variants: 'test'
          }
        end
        run_test!
      end
    end
  end

  path '/api/skills/search' do
    post 'Retrieves a list of users by skills' do
      tags 'Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    tags: {
                      type: :array,
                      required: true,
                      items: {
                        type: :string,
                        example: 'skillOne'
                      }
                    }
                  }
                }

      response '200', 'Returns skills' do
        let(:logged_user) { create :user }
        let(:skill) { create :skill }
        let(:params) { { tags: [skill.title] } }

        run_test!
      end
    end
  end
end
