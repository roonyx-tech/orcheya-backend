require 'swagger_helper'

describe 'Users - Skills API' do
  path '/api/users/{user_id}/skill_updates' do
    post 'Update user skills levels' do
      tags 'Users - Skills'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

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
                      skill_id: {
                        type: :integer,
                        example: 1,
                        required: true
                      },
                      level: {
                        type: :integer,
                        example: 1,
                        required: true
                      }
                    }
                }

      response '200', 'Skill level updated' do
        let(:logged_user) do
          user = create :user
          user.skills << Skill.new(difficulty_level_id: 1, title: 'test_skill')
          user
        end
        let(:user_id) { logged_user.id }
        let(:body) do
          { skill_id: logged_user.skills.last.id, level: 2 }
        end

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          skill_last_update = data[:users_skill][:skill_last_update]
          expect(skill_last_update[0][:level]).to eq(2)
        end
      end
    end
  end

  path '/api/users/{user_id}/bulk_skill_updates' do
    post 'Update user skills levels' do
      tags 'Users - Skills'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      parameter name: :body,
                in: :body,
                schema: {
                  type: :array,
                  items: {
                    type: :object,
                    properties:
                          {
                            skill_id: {
                              type: :integer,
                              example: 1,
                              required: true
                            },
                            level: {
                              type: :integer,
                              example: 1,
                              required: true
                            }
                          }
                  }
                }

      response '200', 'Skills levels updated' do
        let!(:user) { create :user, permissions: { notifications: :skills_update } }
        let(:logged_user) do
          user = create :user
          user.skills << Skill.new(difficulty_level_id: 1, title: 'backend')
          user.skills << Skill.new(difficulty_level_id: 1, title: 'frontend')
          user
        end
        let(:user_id) { logged_user.id }
        let(:body) do
          {
            skill_updates:
              [
                { skill_id: logged_user.skills.first.id, level: 2 },
                { skill_id: logged_user.skills.last.id, level: 2 }
              ]
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          skill_last_update = data[:users_skills][0][:skill_last_update]
          expect(skill_last_update[0][:level]).to eq(2)
        end
      end
    end
  end

  path '/api/users/{user_id}/skill_updates/{id}' do
    put 'Approve user skill' do
      tags 'Users - Skills'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

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
                      id: {
                        type: :integer,
                        example: 1,
                        required: true
                      },
                      users_skill_id: {
                        type: :integer,
                        example: 1,
                        required: true
                      },
                      level: {
                        type: :integer,
                        example: 1,
                        required: true
                      },
                      approved: {
                        type: :integer,
                        example: 1,
                        required: true
                      },
                      approver_id: {
                        type: :integer,
                        example: 1,
                        required: true
                      },
                      comment: {
                        type: :integer,
                        example: '',
                        required: false
                      }
                    }
                }

      response '200', 'Skill approved' do
        let(:logged_user) { create :admin }
        let!(:user) do
          user = create :user, email: 'test@email.com', name: 'test', surname: 'test'
          user.skills << Skill.new(title: 'test', difficulty_level: DifficultyLevel.new)
          user
        end

        let!(:skill_update) do
          update = SkillsUpdate.new(users_skill_id: user.users_skills.first.id,
                                    level: 1, approved: false,
                                    approver_id: logged_user.id)
          update.save!
          update
        end

        let(:user_id) { user.id }
        let(:id) { skill_update.id }

        let(:body) do
          { id: skill_update.id,
            users_skill_id: user.users_skills.first.id,
            level: 2,
            approved: true,
            approver_id: logged_user.id,
            comment: '',
            updated_at: Time.zone.today }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          skill_last_update = data[:skill_last_update]
          expect(skill_last_update[0][:approved]).to eq(true)
        end
      end

      response '422', 'Skill error' do
        let(:logged_user) { create :admin }
        let!(:user) do
          user = create :user, email: 'test@email.com', name: 'test', surname: 'test'
          user.skills << Skill.new(title: 'test', difficulty_level: DifficultyLevel.new)
          user
        end

        let!(:skill_update) do
          update = SkillsUpdate.new(users_skill_id: user.users_skills.first.id,
                                    level: 1, approved: false,
                                    approver_id: logged_user.id)
          update.save!
          update
        end

        let(:user_id) { user.id }
        let(:id) { skill_update.id }

        let(:body) do
          { id: skill_update.id,
            users_skill_id: nil,
            level: nil,
            approved: nil,
            approver_id: nil,
            comment: nil,
            updated_at: nil }
        end

        run_test!
      end
    end
  end
end
