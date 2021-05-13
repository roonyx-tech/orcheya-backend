require 'swagger_helper'

describe 'Difficulty levels API' do
  path '/api/difficulty_levels' do
    get 'Get difficulty levels' do
      tags 'Difficulty levels'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns list skills' do
        let(:logged_user) { create :user }

        run_test!
      end
    end

    post 'Create difficulty level' do
      tags 'Difficulty levels'
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
                      value: {
                        type: :integer,
                        example: 1
                      }
                    }
                }

      response '200', 'Difficulty level created' do
        let(:logged_user) { create :user }
        let(:body) do
          {
            title: 'test',
            value: 1
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          difficulty_level = data[:difficulty_level]
          expect(difficulty_level[:title]).to eq('test')
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
            title: nil
          }
        end
        run_test!
      end
    end
  end

  path '/api/difficulty_levels/{id}' do
    put 'Update difficulty level' do
      tags 'Difficulty levels'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                description: 'difficulty level id',
                required: true,
                schema: {
                  type: :integer,
                  example: 1
                }

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
                      value: {
                        type: :integer,
                        example: 1
                      }
                    }
                }

      response '200', 'Difficulty level updated' do
        let(:logged_user) { create :user }
        let(:difficulty_level) { create :difficulty_level }
        let(:id) { difficulty_level.id }
        let(:body) do
          {
            title: 'test',
            value: 1
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          difficulty_level = data[:difficulty_level]
          expect(difficulty_level[:title]).to eq('test')
        end
      end

      response '401', 'needs to be signed in' do
        let(:logged_user) { nil }
        let(:difficulty_level) { create :difficulty_level }
        let(:id) { difficulty_level.id }
        let(:body) do
          {
            title: 'test',
            value: 1
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:error]).to eq('You need to sign in or sign up before continuing.')
        end
      end

      response '422', 'failure' do
        let(:logged_user) { create :user }
        let(:difficulty_level) { create :difficulty_level }
        let(:id) { difficulty_level.id }
        let(:body) do
          {
            title: nil
          }
        end
        run_test!
      end
    end

    delete 'Destroy difficulty level' do
      tags 'Difficulty levels'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                description: 'difficulty level id',
                required: true,
                schema: {
                  type: :integer,
                  example: 1
                }

      response '200', 'Difficulty level destroyed' do
        let(:logged_user) { create :user }
        let(:difficulty_level) { create :difficulty_level }
        let(:id) { difficulty_level.id }
        run_test!
      end

      response '401', 'needs to be signed in' do
        let(:logged_user) { nil }
        let(:difficulty_level) { create :difficulty_level }
        let(:id) { difficulty_level.id }
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:error]).to eq('You need to sign in or sign up before continuing.')
        end
      end
    end
  end
end
