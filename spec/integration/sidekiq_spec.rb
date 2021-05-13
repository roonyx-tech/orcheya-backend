require 'swagger_helper'

describe 'Sidekiq' do
  path '/sidekiq' do
    get 'Open page' do
      tags 'Sidekiq'
      security [basic: []]

      response '200', 'authentication success' do
        let!(:user) { create :admin, permissions: { admin: :super_admin } }
        let(:Authorization) { "Basic #{::Base64.strict_encode64('admin@roonyx.tech:123456')}" }
        run_test!
      end

      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end
  end
end
