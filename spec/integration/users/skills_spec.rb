require 'swagger_helper'

describe 'Users - Skills API' do
  path '/api/users/{user_id}/skills' do
    get 'Retrieves user skills' do
      tags 'Users - Skills'
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

      response '200', 'returns list skills' do
        let(:logged_user) { create :user }
        let(:user_id) { logged_user.id }

        run_test!
      end
    end
  end

  path '/api/users/{user_id}/skills/{skill_id}' do
    delete 'Delete user skill' do
      tags 'Users - Skills'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      parameter name: :skill_id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      response '200', 'Skill deleted' do
        let(:logged_user) { create :user }
        let(:user_id) { logged_user.id }
        let(:skill_id) { logged_user.users_skills.first.id }

        before(:each) do
          logged_user.skills << Skill.new(difficulty_level_id: 1, title: 'title')
        end

        run_test! do
          expect(User.find_by(id: logged_user.id).skills).to eq([])
        end
      end
    end
  end
end
