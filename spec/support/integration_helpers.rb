module IntegrationHelpers
  extend ActiveSupport::Concern

  shared_context :needs_authorized_user do
    response '401', 'failure' do
      let(:logged_user) { nil }

      run_test!
    end

    response '403', 'forbidden' do
      let(:logged_user) { create :user }

      run_test!
    end
  end
end
