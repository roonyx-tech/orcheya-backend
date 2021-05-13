require 'swagger_helper'

describe 'Users - Links API' do
  path '/api/users/{user_id}/links' do
    get 'index' do
      tags 'Users - Links'
      security [apiKey: []]
      produces 'application/json'
      consumes 'application/json'

      parameter name: :user_id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      response '200', 'returns list of links' do
        let(:logged_user) { create :user }
        let(:user_id) { logged_user.id }

        run_test!
      end
    end

    post 'create' do
      tags 'Users - Links'
      security [apiKey: []]
      produces 'application/json'
      consumes 'application/json'

      parameter name: :user_id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      parameter name: :params,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    link: {
                      type: :string,
                      required: true,
                      example: 'test'
                    }
                  }
                }

      response '200', 'returns list of links' do
        let(:logged_user) { create :user }
        let(:user_id) { logged_user.id }
        let(:params) { { link: Faker::Internet.url } }

        run_test!
      end
    end
  end

  path '/api/users/{user_id}/links/{id}' do
    put 'update' do
      tags 'Users - Links'
      security [apiKey: []]
      produces 'application/json'
      consumes 'application/json'

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

      parameter name: :params,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    link: {
                      type: :string,
                      required: true,
                      example: 'test'
                    }
                  }
                }

      response '200', 'returns list of links' do
        let(:logged_user) { create :user }
        let(:user_id) { logged_user.id }
        let!(:link1) { create :link, user: logged_user }
        let(:id) { link1.id }
        let(:params) { { link: Faker::Internet.url } }

        run_test!
      end
    end

    delete 'destroy' do
      tags 'Users - Links'
      security [apiKey: []]
      produces 'application/json'
      consumes 'application/json'

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

      response '204', 'returns list of links' do
        let(:logged_user) { create :user }
        let(:user_id) { logged_user.id }
        let!(:link1) { create :link, user: logged_user }
        let(:id) { link1.id }

        run_test!
      end
    end
  end
end
