require 'swagger_helper'

describe 'Users - Achievements API' do
  path '/api/users/{user_id}/achievements' do
    get 'Get user achievements' do
      tags 'Users - Achievements'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      response '401', 'needs to be signed in' do
        let(:user_id) { nil }

        run_test!
      end

      response '200', 'returns list achievements' do
        let(:logged_user) { create :user }
        let(:user_id) { logged_user.id }

        run_test!
      end
    end
  end

  path '/api/users/{user_id}/achievements/{id}/set_favorite' do
    put 'Get user achievements' do
      tags 'Users - Achievements'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      parameter name: :user_id,
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
                        favorite: {
                          type: :boolean,
                          example: true
                        }
                      }
                }

      response '401', 'needs to be signed in' do
        let(:user_id) { 99 }
        let(:id) { 999 }

        run_test!
      end

      response '200', 'returns list achievements' do
        before do
          user = create :user
          create_list :achievement, 2
          user.achievements << Achievement.all
          user.users_achievements.first.update(favorite: true)
          user.users_achievements.last.update(favorite: true)
        end

        let(:logged_user) { create :user }
        let(:user_id) { logged_user.id }
        let(:achievement) { create :achievement, users: [logged_user] }
        let(:id) { achievement.users_achievements.first.id }

        run_test!
      end
    end
  end
end
