require 'swagger_helper'

describe 'Discord Integration API' do
  path '/api/integration/discord/' do
    get 'Discord Connection' do
      tags 'Discord Integration'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns discord uri' do
        let(:logged_user) { create :user }
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:uri]).to start_with('https://discordapp.com/api/oauth2/authorize')
        end
      end
    end
  end

  path '/api/integration/discord/callback' do
    get 'Discord Callback' do
      tags 'Discord Integration'
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

      context 'Successfully connects to Discord' do
        before do
          stub_request(:post, 'https://discordapp.com/api/oauth2/token')
            .with(
              body: { client_id: nil, client_secret: nil, code: nil, grant_type: 'authorization_code',
                      redirect_uri: 'http://www.example.com/api/integration/discord/callback', scope: 'identify' }
            )
            .to_return(status: 200, body: { access_token: 'access_token', refresh_token: 'refresh_token' }.to_json,
                       headers: {})

          stub_request(:get, 'https://discordapp.com/api/v6/users/@me')
            .with(
              headers: { 'Authorization' => 'Bearer access_token', 'Host' => 'discordapp.com' }
            )
            .to_return(status: 200, body: { id: '1', username: 'Username' }.to_json, headers: {})

          stub_request(:post, 'https://discordapp.com/api/v6/users/@me/channels')
            .with(
              body: { "recipient_id": '1' },
              headers: { 'Authorization' => 'Bot', 'Host' => 'discordapp.com' }
            )
            .to_return(status: 200, body: { id: 1 }.to_json, headers: {})
          Rails.application.credentials.frontend_url = 'http://orcheya.com'
        end

        response '302', 'connects to DiscordService' do
          temp_token = SecureRandom.uuid
          let(:logged_user) do
            create :user, temp_referer: 'http://orcheya.com/profile?tab=settings', temp_integration_token: temp_token
          end
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

  path '/api/integration/discord/disconnect' do
    get 'Discord Callback' do
      tags 'Discord Integration'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns discord uri' do
        let(:logged_user) { create :user }
        run_test!
      end
    end
  end
end
