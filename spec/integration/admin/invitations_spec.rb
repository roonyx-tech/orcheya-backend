require 'swagger_helper'

describe 'Users - Invitations API' do
  path '/api/admin/invitations' do
    post 'creates user invitation' do
      tags 'Admin - Invitations'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :body,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        name: { type: :string, example: 'name' },
                        surname: { type: :string, example: 'surname' },
                        sex: { type: :integer, example: 1 },
                        phone: { type: :integer, example: 88_005_553_535 },
                        roles: { type: :bigint, example: [1] },
                        employment_at: { type: :string, example: Time.zone.today },
                        working_hours: { type: :integer, example: 35 },
                        timing_id: { type: :bigint, example: 1 },
                        email: { type: :string, example: 'email@email.ru' },
                        onboarding_attributes: {
                          type: :object,
                          required: true,
                          properties: {
                            gmail_login: { type: :string, example: 'user@roonyx.tech' },
                            gmail_password: { type: :string, example: '123456' },
                            jira_tool: { type: :boolean, example: false },
                            gitlab_tool:  { type: :boolean, example: true },
                            timedoctor_tool: { type: :boolean, example: true },
                            documents_attributes: {
                              type: :array,
                              items: {
                                type: :object,
                                properties: {
                                  name: { type: :string, example: 'KMB' },
                                  link: { type: :string, example: 'https://drive.google.com' }
                                }
                              }
                            }
                          }
                        }
                      },
                      required: %w[roles]
                    }
                  },
                  required: true
                }

      response '401', 'needs to be signed in' do
        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:logged_user) { create :user, permissions: { users: :crud } }
        let!(:role) { create :role }
        let(:body) do
          { user: { name: 'test', roles: [role.id] } }
        end

        run_test!
      end

      response '200', 'returns created user invite' do
        let(:logged_user) { create :user, permissions: { users: :crud } }
        let!(:role) { create :role }
        let(:body) do
          { user: { name: 'test',
                    surname: 'tester',
                    email: 'user@roonyx.tech',
                    roles: [role.id],
                    employment_at: Time.zone.today,
                    working_hours: 35,
                    onboarding_attributes: {
                      gmail_login: 'user@roonyx.tech', gmail_password: '123456',
                      jira_tool: false, gitlab_tool: true, timedoctor_tool: true,
                      documents_attributes: [{ name: 'test', link: 'link' }]
                    } } }
        end

        run_test!
      end
    end
  end

  path '/api/admin/invitations/{id}' do
    get 'updates user invitation' do
      tags 'Admin - Invitations'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                description: 'user id',
                required: true,
                schema: {
                  type: :integer,
                  example: 1
                }

      response '200', 'returns user invitation' do
        let(:logged_user) { create :user, permissions: { users: :crud } }
        let!(:invited_user) { create :user, :invited }
        let!(:onboarding) { create :onboarding, user: invited_user, raw_invitation_token: 'sample' }
        let(:id) { invited_user.id }

        run_test!
      end
    end

    put 'updates user invitation' do
      tags 'Admin - Invitations'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                description: 'user id',
                required: true,
                schema: {
                  type: :integer,
                  example: 1
                }

      parameter name: :body,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        name: { type: :string, example: 'name' },
                        surname: { type: :string, example: 'surname' },
                        sex: { type: :integer, example: 1 },
                        phone: { type: :integer, example: 88_005_553_535 },
                        roles: { type: :bigint, example: [1] },
                        employment_at: { type: :string, example: Time.zone.today },
                        working_hours: { type: :integer, example: 35 },
                        timing_id: { type: :bigint, example: 1 },
                        email: { type: :string, example: 'email@email.ru' },
                        onboarding_attributes: {
                          type: :object,
                          properties: {
                            gmail_login: { type: :string, example: 'user@roonyx.tech' },
                            gmail_password: { type: :string, example: '123456' },
                            jira_tool: { type: :boolean, example: false },
                            gitlab_tool:  { type: :boolean, example: true },
                            timedoctor_tool: { type: :boolean, example: true }
                          }
                        }
                      },
                      required: %w[roles]
                    }
                  },
                  required: true
                }

      response '401', 'needs to be signed in' do
        let!(:invited_user) { create :user, :invited }
        let(:id) { invited_user.id }
        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:logged_user) { create :user, permissions: { users: :crud } }
        let!(:invited_user) { create :user, :invited }
        let!(:role) { create :role }
        let(:id) { invited_user.id }
        let(:body) do
          { user: { name: nil, surname: nil, email: nil, roles: [role.id] } }
        end

        run_test!
      end

      response '200', 'returns updated user invite' do
        let!(:invited_user) { create :user, :invited }
        let!(:onboarding) { create :onboarding, user: invited_user, raw_invitation_token: 'sample' }
        let(:id) { invited_user.id }
        let(:logged_user) { create :user, permissions: { users: :crud } }
        let!(:role) { create :role }
        let(:body) do
          { user: { name: 'test',
                    surname: 'tester',
                    email: 'user@roonyx.tech',
                    roles: [role.id],
                    employment_at: Time.zone.today,
                    working_hours: 35,
                    onboarding_attributes: {
                      id: onboarding.id,
                      gmail_login: 'user@roonyx.tech', gmail_password: '123456',
                      jira_tool: false, gitlab_tool: true, timedoctor_tool: true
                    } } }
        end

        run_test!
      end
    end
  end

  path '/api/admin/invitations/{id}' do
    delete 'deletes user invitation' do
      tags 'Admin - Invitations'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                description: 'user id',
                required: true,
                schema: {
                  type: :integer,
                  example: 1
                }

      response '401', 'needs to be signed in' do
        let!(:invited_user) { create :user, :invited }
        let(:id) { invited_user.id }
        run_test!
      end

      response '200', 'destroys user invite' do
        let(:logged_user) { create :user, permissions: { users: :crud } }
        let!(:invited_user) { create :user, :invited }
        let(:id) { invited_user.id }
        run_test!
      end
    end
  end
end
