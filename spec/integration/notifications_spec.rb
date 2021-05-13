require 'swagger_helper'

describe 'Notifications API' do
  path '/api/notifications' do
    get 'index' do
      tags 'Notifications'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns list of event tags' do
        let(:logged_user) { create :user }
        let(:event) { create :notification }

        run_test!
      end
    end
  end

  path '/api/notifications/{index}/read' do
    post 'Read' do
      tags 'Notifications'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :index,
                in: :path,
                type: :integer,
                required: true

      response '401', 'needs to be signed in' do
        let(:index) { 1 }
        run_test!
      end

      response '204', 'success' do
        let(:logged_user) { create :user }
        let(:notification) { create :notification, user: logged_user }

        let(:index) { notification.id }

        run_test!
      end

      response '403', 'failure' do
        let(:logged_user) { create :user }
        let(:other_user) { create :user }
        let(:notification) { create :notification, user: other_user }

        let(:index) { notification.id }

        run_test!
      end
    end
  end

  path '/api/notifications/read_all' do
    post 'Read all' do
      tags 'Notifications'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '401', 'needs to be signed in' do
        run_test!
      end

      response '204', 'success' do
        let(:logged_user) { create :user }
        let(:other_user) { create :user }
        let!(:notification1) { create :notification, user: logged_user }
        let!(:notification2) { create :notification, user: other_user }

        run_test! do
          expect(Notification.unscoped.find(notification1.id).readed_at).to be_truthy
          expect(Notification.unscoped.find(notification2.id).readed_at).to be_nil
        end
      end
    end
  end
end
