require 'swagger_helper'

describe 'Admin - Skills API' do
  path '/api/admin/skills' do
    get 'Get user skills' do
      tags 'Admin - Skills'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns list skills' do
        let(:logged_user) { create :user, permissions: { admin: :skills } }
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
                      },
                      approved: {
                        type: :boolean,
                        example: true,
                        required: true
                      }
                    }
                }

      response '200', 'Skill created' do
        let(:logged_user) { create :user, permissions: { admin: :skills } }
        let(:body) do
          {
            approved: true,
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
        let(:logged_user) { create :user, permissions: { admin: :skills } }
        let(:body) do
          {
            approved: true,
            difficulty_level_id: '2',
            title: nil,
            variants: 'test'
          }
        end
        run_test!
      end
    end
  end

  path '/api/admin/skills/{id}' do
    put 'Update user skills' do
      tags 'Admin - Skills'
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
                      difficulty_level_id: {
                        type: :bigint,
                        example: 1,
                        required: true
                      },
                      variants: {
                        type: :text,
                        example: 'text',
                        required: true
                      },
                      approved: {
                        type: :boolean,
                        example: true,
                        required: true
                      }
                    }
                }

      response '200', 'Skill updated' do
        let(:logged_user) { create :user, permissions: { admin: :skills } }
        let(:body) do
          { skill_id: 2, level: 2 }
        end

        before(:each) do
          skill = Skill.create(approved: true,
                               difficulty_level_id: '2',
                               title: 'test',
                               variants: 'test')
          skill.save!
        end

        let(:id) { Skill.last.id }
        let(:body) do
          { title: 'test_title' }
        end

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          skill = data[:skill]
          expect(skill[:title]).to eq('test_title')
        end
      end

      response '422', 'Unprocessable' do
        let(:logged_user) { create :user, permissions: { admin: :skills } }
        let(:body) do
          { skill_id: 2, level: 2 }
        end

        before(:each) do
          skill = Skill.create(approved: true,
                               difficulty_level_id: '2',
                               title: 'test',
                               variants: 'test')
          skill.save!
        end

        let(:id) { Skill.last.id }
        let(:body) do
          { title: '' }
        end

        run_test!
      end
    end

    delete 'Delete user skill' do
      tags 'Admin - Skills'
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
                      difficulty_level_id: {
                        type: :bigint,
                        example: 1,
                        required: true
                      },
                      variants: {
                        type: :text,
                        example: 'text',
                        required: true
                      },
                      approved: {
                        type: :boolean,
                        example: true,
                        required: true
                      }
                    }
                }

      response '200', 'Skill deleted' do
        let(:logged_user) { create :user, permissions: { admin: :skills } }
        before(:each) do
          skill = Skill.create(approved: true,
                               difficulty_level_id: '2',
                               title: 'test',
                               variants: 'test')
          skill.save!
        end

        let(:id) { Skill.last.id }

        run_test!
      end
    end
  end
end
