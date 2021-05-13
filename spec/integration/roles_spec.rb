require 'swagger_helper'

describe 'Roles' do
  path '/api/roles' do
    get 'index' do
      tags 'Roles'
      security [apiKey: []]
      produces 'application/json'

      response '200', 'success' do
        let(:logged_user) { create :user }
        before { create_list(:role, 3) }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data.length).to eq(3)
        end
      end
    end

    post 'create' do
      tags 'Roles'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :role,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    name: {
                      type: :string,
                      required: true,
                      example: 'test'
                    },
                    permissions: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          id: {
                            type: :integer,
                            example: 1
                          }
                        }
                      },
                      required: true
                    }
                  }
                }

      response '401', 'unauthorized' do
        let(:logged_user) { nil }
        let(:role) { nil }

        run_test!
      end

      response '403', 'forbidden' do
        let(:logged_user) { create :user }
        let(:role) { build :role }

        run_test!
      end

      response '200', 'success' do
        let(:logged_user) { create :user, permissions: { admin: :roles } }
        let(:role) do
          {
            name: 'test',
            permissions: []
          }
        end

        run_test_with_examples!
      end

      response '422', 'wrong data' do
        let(:logged_user) { create :user, permissions: { admin: :roles } }
        let(:role) do
          {
            name: nil,
            permissions: []
          }
        end

        run_test!
      end
    end
  end

  path '/api/roles/{id}' do
    get 'show' do
      tags 'Roles'
      security [apiKey: []]
      produces 'application/json'
      parameter name: :id,
                example: 1,
                in: :path,
                type: :integer,
                required: true

      let(:role) { create :role }

      response '401', 'unauthorized' do
        let(:logged_user) { nil }
        let(:id) { role.id }

        run_test!
      end

      response '200', 'success' do
        let(:logged_user) { create :user }
        let(:id) { role.id }

        run_test_with_examples!
      end
    end

    put 'update' do
      tags 'Roles'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                example: 1,
                in: :path,
                type: :integer,
                required: true

      parameter name: :role,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    name: {
                      type: :string,
                      required: true,
                      example: 'test'
                    },
                    permissions: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          id: {
                            type: :integer,
                            example: 1
                          }
                        }
                      },
                      required: true
                    }
                  }
                }

      response '401', 'unauthorized' do
        let(:logged_user) { nil }
        let(:role) { nil }
        let(:id) { 1 }

        run_test!
      end

      response '403', 'forbidden' do
        let(:logged_user) { create :user }
        let(:role) { create :role }
        let(:id) { role.id }

        run_test!
      end

      response '200', 'success' do
        let!(:created_role) { create :role }
        let(:logged_user) { create :user, permissions: { admin: :roles } }
        let(:id) { created_role.id }
        let(:role) do
          {
            name: 'test',
            permissions: []
          }
        end

        run_test_with_examples! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:name]).to eq('test')
        end
      end

      response '422', 'wrong data' do
        let!(:created_role) { create :role }
        let(:logged_user) { create :user, permissions: { admin: :roles } }
        let(:id) { created_role.id }
        let(:role) do
          {
            name: nil,
            permissions: []
          }
        end

        run_test!
      end
    end

    delete 'destroy' do
      tags 'Roles'
      security [apiKey: []]
      produces 'application/json'
      parameter name: :id,
                example: 1,
                in: :path,
                type: :integer,
                required: true

      parameter name: :new_role,
                in: :query,
                example: 1,
                type: :integer,
                required: false

      let(:role) { create :role }
      response '401', 'unauthorized' do
        let(:logged_user) { nil }
        let(:id) { role.id }

        run_test!
      end

      response '403', 'forbidden' do
        let(:logged_user) { create :user }
        let(:id) { role.id }

        run_test!
      end

      response '200', 'success' do
        let(:logged_user) { create :user, permissions: { admin: :roles } }
        let(:id) { role.id }

        run_test!
      end

      response '200', 'success with new role' do
        let!(:role2) { create :role }
        let!(:user) { create :user, roles: [role] }
        let(:logged_user) { create :user, permissions: { admin: :roles } }
        let(:id) { role.id }
        let(:new_role) { role2.id }

        run_test!
      end
    end
  end
end
