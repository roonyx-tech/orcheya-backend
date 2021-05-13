require 'swagger_helper'

describe 'Users - Invitations API' do
  path '/api/users/{user_token}/invitation' do
    get 'show user invitation' do
      tags 'Users - Invitations'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_token,
                in: :path,
                type: :string,
                description: 'raw_invitation_token',
                required: true

      before do
        user = create :user, :invited
        onboarding = Onboarding.create(user: user, raw_invitation_token: 'sample_token',
                                       gmail_login: 'test', gmail_password: 'qwerty')
        step = Step.create(name: 'test_step', link: 'test_link')
        OnboardingStep.create(onboarding: onboarding, step: step)
      end

      response '200', 'returns user invite' do
        let(:user_token) { Onboarding.first.raw_invitation_token }

        run_test!
      end
    end

    put 'updates user invitation' do
      tags 'Users - Invitations'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_token,
                in: :path,
                type: :string,
                description: 'raw_invitation_token',
                required: true

      parameter name: :body,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      required: true,
                      properties: {
                        password: { type: :string, example: 'qwerty' },
                        onboarding_attributes: {
                          type: :object,
                          required: true,
                          properties: {
                            id: { type: :bigint, example: 1 },
                            documents_attributes: {
                              type: :object,
                              required: true,
                              properties: {
                                id: { type: :bigint, example: 1 },
                                read: { type: :boolean, example: true }
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  required: true
                }

      before do
        user = create :user, :invited
        onboarding = Onboarding.create(user: user, raw_invitation_token: 'sample_token',
                                       gmail_login: 'test', gmail_password: 'qwerty')
        step = Step.create(name: 'test_step', link: 'test_link', kind: 'document')
        OnboardingStep.create(onboarding: onboarding, step: step)
      end

      response '200', 'returns updated user invite' do
        let(:user_token) { Onboarding.first.raw_invitation_token }
        let(:body) do
          {
            user: {
              password: '123456',
              onboarding_attributes: {
                id: Onboarding.first.id,
                onboarding_steps_attributes: [
                  { id: OnboardingStep.first.id, read: true }
                ]
              }
            }
          }
        end

        run_test!
      end

      response '422', 'returns user invitation error' do
        let(:user_token) { Onboarding.first.raw_invitation_token }
        let(:body) do
          {
            user: {
              password: '   ',
              onboarding_attributes: {
                id: Onboarding.first.id,
                onboarding_steps_attributes: [
                  { id: OnboardingStep.first.id, read: true }
                ]
              }
            }
          }
        end

        run_test!
      end
    end
  end
end
