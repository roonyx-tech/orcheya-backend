require 'swagger_helper'

describe 'Profile API' do
  path '/api/profile' do
    get 'Retrieves a profile' do
      tags 'Profile'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '401', 'user unauthorized' do
        schema '$ref' => '#/definitions/single_error'
        run_test!
      end

      response '200', 'user authorized' do
        let(:logged_user) { create :user }

        run_test_with_examples! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:user][:id]).to eq(logged_user.id)
        end
      end

      response '200', 'user authorized without avatar' do
        let(:logged_user) { create(:user, :no_avatar) }

        run_test_with_examples! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:user][:id]).to eq(logged_user.id)
        end
      end
    end

    put 'Update a profile' do
      tags 'Profile'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user,
                in: :body,
                type: :object,
                description: 'update info',
                required: true,
                schema: { '$ref' => '#/definitions/user' }

      response '401', 'failure' do
        let(:user) { create :user }

        schema '$ref' => '#/definitions/single_error'
        run_test!
      end

      response '200', 'valid info' do
        let(:logged_user) { create :user }
        let(:user) { { user: logged_user.attributes.merge(name: 'New_name') } }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          user = data[:user]
          expect(user[:id]).to eq(logged_user.id)
          expect(user[:name]).to eq('New_name')
          expect(user[:registration_finished]).to be_truthy
        end
      end

      response '422', 'invalid info' do
        let(:logged_user) { create :user }
        let(:user) do
          {
            user: logged_user.attributes.merge(name: nil, surname: nil)
          }
        end

        schema '$ref' => '#/definitions/errors_object'
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:name]).to eq(["can't be blank"])
          expect(data[:surname]).to eq(["can't be blank"])
        end
      end
    end
  end

  path '/api/profile/edit' do
    get 'Edit profile' do
      tags 'Profile'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'Edit profile' do
        let(:logged_user) { create :user }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end

  path '/api/profile/update_avatar' do
    put 'Update avatar' do
      tags 'Profile'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user,
                in: :body,
                type: :object,
                description: 'update info',
                required: true

      response '200', 'valid info' do
        let(:logged_user) { create :user, :no_avatar }
        let(:user) { { user: (create :user) } }
        run_test!
      end

      response '401', 'failure' do
        let(:user) { create :user }

        schema '$ref' => '#/definitions/single_error'
        run_test!
      end
    end
  end
end
