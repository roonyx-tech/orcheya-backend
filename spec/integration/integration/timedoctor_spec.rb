require 'swagger_helper'

describe 'TimeDoctor Integration API' do
  path '/api/integration/timedoctor/' do
    get 'TimeDoctor Connection' do
      tags 'TimeDoctor Integration'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      before { Rails.application.credentials.timedoctor_client_id = 'test-id' }

      response '200', 'returns timedoctor uri' do
        let(:logged_user) { create :user }
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:uri]).to start_with('https://webapi.timedoctor.com/oauth/v2/auth')
        end
      end
    end
  end

  path '/api/integration/timedoctor/callback' do
    get 'TimeDoctor Callback' do
      tags 'TimeDoctor Integration'
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

      context 'Successfully connects to TimeDoctor' do
        temp_token = SecureRandom.uuid
        let(:logged_user) do
          create :user, temp_referer: 'http://orcheya.com/profile?tab=settings', temp_integration_token: temp_token
        end

        before do
          stub_request(:get, 'https://webapi.timedoctor.com/oauth/v2/token?_format=json&client_id=&client_secret=&code&grant_type=authorization_code&redirect_uri=http://www.example.com/api/integration/timedoctor/callback')
            .to_return(body: JSON.generate(
              ok: true,
              access_token: temp_token,
              refresh_token: SecureRandom.uuid
            ))
          stub_request(:get, "https://webapi.timedoctor.com/v1.1/companies?_format=json&access_token=#{temp_token}")
            .to_return(body: JSON.generate(
              ok: true,
              user: { user_id: 1, company_id: 2 }
            ))
          Rails.application.credentials.frontend_url = 'http://orcheya.com'
        end

        response '302', 'trying to connect to TimeDoctorService' do
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

  path '/api/integration/timedoctor/disconnect' do
    get 'TimeDoctor Callback' do
      tags 'TimeDoctor Integration'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns timedoctor uri' do
        let(:logged_user) { create :user }
        run_test!
      end
    end
  end
end
