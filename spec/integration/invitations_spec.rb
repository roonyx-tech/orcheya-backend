require 'swagger_helper'

describe 'Invitation API' do
  path '/api/users/invitation' do
    put 'Accept a token' do
      tags 'Invitation'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :invitation,
                in: :body,
                type: :object,
                description: 'invitation token',
                required: true

      response '201', 'valid invitation token' do
        let(:invited_user) { create :user, :invited }
        let(:invitation) do
          {
            invitation_token: invitation_token,
            password: '123456',
            name: 'test',
            surname: 'testSur',
            timing_id: create(:timing)
          }
        end

        run_test!
      end

      response '406', 'invalid invitation token' do
        let(:invited_user) { create :user }
        let(:invitation) do
          {
            invitation_token: 'fakeinvitationtoken',
            password: '123456'
          }
        end

        run_test_with_examples!
      end
    end
  end
end
