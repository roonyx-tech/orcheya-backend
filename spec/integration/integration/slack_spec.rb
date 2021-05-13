require 'swagger_helper'

describe 'Slack Integration API' do
  path '/api/integration/slack/' do
    get 'Slack Connection' do
      tags 'Slack Integration'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns slack uri' do
        let(:logged_user) { create :user }
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:uri]).to start_with('https://slack.com/oauth/authorize')
        end
      end
    end
  end

  path '/api/integration/slack/callback' do
    get 'Slack Callback' do
      tags 'Slack Integration'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :state,
                in: :query,
                type: :string,
                example: 'title',
                required: false

      parameter name: :error,
                in: :query,
                type: :string,
                example: 'error',
                required: false

      context 'Successfully connects to Slack' do
        temp_token = SecureRandom.uuid
        let(:logged_user) do
          create :user, temp_referer: 'http://orcheya.com/profile?tab=settings', temp_integration_token: temp_token
        end

        before do
          stub_request(:get, 'https://slack.com/api/oauth.access?client_id&client_secret&code&redirect_uri=http://www.example.com/api/integration/slack/callback')
            .to_return(status: 200, body: { user_id: logged_user.id, team_id: 9, access_token: 'access_token' }.to_json,
                       headers: {})
          stub_request(:post, 'https://slack.com/api/users.info')
            .to_return(body: JSON.generate(
              ok: true,
              user: { id: 'W012A3CDE', team_id: 'T012AB3C4', profile: { real_name_normalized: 'Egon Spengler' } }
            ))
          Rails.application.credentials.frontend_url = 'http://orcheya.com'
        end

        response '302', 'connects to SlackService' do
          let!(:state) { temp_token }
          run_test!
        end

        response '406', 'redirect with not acceptable' do
          temp_token = SecureRandom.uuid
          let(:logged_user) do
            create :user, temp_referer: 'xyz', temp_integration_token: temp_token
          end
          let!(:state) { temp_token }
          run_test!
        end
      end

      context 'Redirect with error' do
        response '302', 'redirect to frontend uri' do
          let(:logged_user) do
            create :user
          end
          let(:error) { 'Error' }
          run_test!
        end
      end
    end
  end

  path '/api/integration/slack/disconnect' do
    get 'Slack Callback' do
      tags 'Slack Integration'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns slack uri' do
        let(:logged_user) { create :user }
        run_test!
      end
    end
  end
end
