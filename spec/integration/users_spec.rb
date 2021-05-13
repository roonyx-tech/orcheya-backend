require 'swagger_helper'

describe 'User session API' do
  path '/api/users/sign_in' do
    post 'sign in by email and password' do
      tags 'Session'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'admin@roonyx.tech' },
              password: { type: :string, example: '123456' }
            },
            required: %w[email password]
          }
        },
        required: true
      }

      response '201', 'returns user profile with token in headers' do
        let(:user) { create :user }
        # user_params created on login_helpers.rb
        header 'Authorization', type: :string, description: 'Access token'
        run_test_with_examples!
      end

      response '401', 'failure' do
        let(:user_params) { nil }
        schema '$ref' => '#/definitions/single_error'
        run_test!
      end

      response '401', 'failure with not accepted invite' do
        let(:user) { create(:user).tap(&:invite!) }
        let(:user_params) { { user: user.slice(:email, :password) } }
        schema '$ref' => '#/definitions/single_error'
        run_test!
      end
    end
  end

  path '/api/users/sign_out' do
    delete 'sign out the user' do
      tags 'Session'
      security [apiKey: []]
      produces 'application/json'

      response '204', 'removes token' do
        let(:logged_user) { create :user }
        run_test!
      end
    end
  end
end

describe 'Dashboard' do
  path '/api/dashboards' do
    get 'Retrieves a best users' do
      tags 'Users'
      security [apiKey: []]
      produces 'application/json'

      response '200', 'returns best users' do
        let(:logged_user) { create :user }
        let(:user_id) { logged_user.id }

        run_test!
      end

      response '401', 'failure' do
        let(:user_params) { nil }
        schema '$ref' => '#/definitions/single_error'
        run_test!
      end
    end
  end
end

describe 'User resource' do
  path '/api/users' do
    get 'Retrieves a users list' do
      tags 'Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :page,
                in: :query,
                type: :integer,
                description: 'number of page for pagination',
                minimum: 1,
                required: false

      parameter name: :limit,
                in: :query,
                type: :integer,
                description: 'max count of records',
                minimum: 1,
                required: false

      parameter name: :search,
                in: :query,
                type: :string,
                description: 'search by name or surname',
                required: false

      response '200', 'returns users list' do
        let(:logged_user) { create :user }
        let(:page) { 1 }
        run_test!
      end

      response '200', 'returns users list with search' do
        let(:logged_user) { create :user }
        let(:search) { 'King' }
        run_test!
      end

      response '401', 'failure' do
        let(:user_params) { nil }
        schema '$ref' => '#/definitions/single_error'
        run_test!
      end
    end
  end

  path '/api/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                description: 'user id',
                minimum: 1,
                required: true,
                example: 1

      response '200', 'returns user' do
        let(:logged_user) { create :user }
        let(:id) { logged_user.id }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:user][:id]).to eq(logged_user.id)
        end
      end

      response '404', 'fail, user not exist' do
        let(:logged_user) { create :user }
        let(:id) { -1 }
      end

      response '401', 'failure' do
        let(:user_params) { nil }
        let(:id) { 1 }
        schema '$ref' => '#/definitions/single_error'
        run_test!
      end
    end

    path '/api/users/{id}' do
      put 'Update user data' do
        tags 'Users'
        security [apiKey: []]
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id,
                  in: :path,
                  type: :integer,
                  description: 'user id',
                  required: true,
                  schema: {
                    type: :integer,
                    example: 1
                  }

        parameter name: :body,
                  in: :body,
                  schema: {
                    type: :object,
                    properties: {
                      user: {
                        type: :object,
                        properties: {
                          name: { type: :string, example: 'name' },
                          employment_at: { type: :string, example: Time.zone.today },
                          surname: { type: :string, example: 'surname' },
                          skype: { type: :string, example: 'skype' },
                          sex: { type: :integer, example: 1 },
                          role: { type: :integer, example: 1 },
                          phone: { type: :integer, example: 88_005_553_535 },
                          email: { type: :string, example: 'email@email.ru' },
                          birthday: { type: :date, example: Time.zone.today - 30.years },
                          roles: { type: :bigint, example: [1] },
                          english_level: { type: :integer, example: 1 }
                        },
                        required: %w[roles]
                      }
                    },
                    required: true
                  }
        response '200', 'english level updated with \'english_level\' permit' do
          let(:logged_user) { create :user, permissions: { admin: :english_level } }

          let!(:user) { create :user }
          let(:id) { user.id }
          let(:body) do
            { user: { name: 'test',
                      roles: [user.roles.first],
                      english_level: 1 } }
          end

          run_test! do |response|
            data = JSON.parse(response.body, symbolize_names: true)
            user = data[:user]
            expect(user[:english_level]).to eq(1)
          end
        end
        response '422', 'unprocessable entity' do
          let(:logged_user) { create :user, permissions: { admin: :english_level } }

          let!(:user) { create :user }
          let(:id) { user.id }
          let(:body) do
            { user: { name: nil,
                      roles: [user.roles.first],
                      english_level: 8 } }
          end

          run_test!
        end
      end
    end
  end

  path '/api/users/{id}/stats' do
    get 'Retrieves a stats' do
      tags 'Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                description: 'user id',
                minimum: 1,
                required: true,
                example: 1

      response '200', 'returns users stats' do
        let(:logged_user) { create :user }
        let(:id) { logged_user.id }

        run_test_with_examples!
      end

      response '404', 'fail, user not exist' do
        let(:logged_user) { create :user }
        let(:id) { -1 }
      end

      response '401', 'failure' do
        let(:user_params) { nil }
        let(:id) { 1 }
        schema '$ref' => '#/definitions/single_error'
        run_test!
      end
    end
  end

  path '/api/users/{id}/day_info' do
    get 'Retrieves a day info' do
      tags 'Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                description: 'user id',
                minimum: 1,
                required: true,
                example: 1

      parameter name: :date,
                in: :query,
                type: :date,
                description: 'date',
                required: true,
                example: Time.zone.today

      response '200', 'returns user day info' do
        let(:logged_user) { create :user }
        let(:id) { logged_user.id }
        let(:date) { Date.current }

        let!(:project) { create :project }

        let!(:update) { create :update, user_id: id, date: date - 1.day }

        let!(:worklog1) { create(:worklog, user_id: id, date: date, project: project) }
        let!(:worklog2) { create(:worklog, user_id: id, date: date, project: project) }
        let!(:worklog3) { create(:worklog, user_id: id, date: date - 1.day, project: project) }

        run_test! do |response|
          body = JSON.parse(response.body, symbolize_names: true)

          expect(body[:prev_update][:id]).to eq(update.id)
          expect(body[:worked]).to_not be_empty
          expect(body[:current_update]).to be_nil
        end
      end

      response '200', 'returns user day info with commits' do
        let(:logged_user) { create :user }
        let(:id) { logged_user.id }
        let(:date) { Time.zone.today }
        let(:time) { Time.zone.now }
        let(:project) { create :project }
        let!(:commit) { create :commit, user: logged_user, time: time, project: project }

        run_test! do |response|
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:worked]).to_not be_empty
        end
      end
    end
  end

  path '/api/users/{id}/timegraph' do
    get 'Retrieves a timegraph' do
      tags 'Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                description: 'user id',
                minimum: 1,
                required: true,
                example: 1

      parameter name: :start_date,
                in: :query,
                type: :date,
                description: 'start date',
                required: true,
                example: Time.zone.today

      parameter name: :end_date,
                in: :query,
                type: :date,
                description: 'end date',
                required: true,
                example: Time.zone.today

      parameter name: :source,
                in: :query,
                type: :integer,
                description: 'type of time tracker',
                example: 1

      parameter name: :update,
                in: :query,
                type: :boolean,
                description: 'flag of getting updates',
                example: true

      parameter name: :paid,
                in: :query,
                required: false,
                type: :boolean,
                description: 'flag of paid projects',
                example: true

      response '200', 'returns users timegraph' do
        let(:logged_user) { create :user }
        let(:id) { logged_user.id }

        let(:start_date) { Time.zone.now }
        let(:end_date) { start_date }
        let(:source) { 1 }
        let(:update) { true }

        let!(:project) { create :project }

        let!(:worklog1) { create(:worklog, user_id: id, date: start_date, task_id: 12) }
        let!(:worklog2) { create(:worklog, user_id: id, date: start_date, task_id: 13) }
        let!(:worklog3) { create(:worklog, user_id: id, date: (start_date - 1.day), task_id: 12) }
        let!(:user_update) { create :update, user: logged_user, date: start_date }
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   date: { type: :string, example: '2018-03-27' },
                   time: { type: :integer, example: '637' },
                   update: { type: :boolean, update: true }
                 }
               }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[0][:date]).to eq(start_date.strftime('%Y-%m-%d'))
        end
      end

      response '401', 'failure' do
        let(:logged_user) { nil }
        let(:id) { 1 }

        let(:start_date) { Time.zone.now }
        let(:end_date) { start_date }
        let(:source) { 1 }
        let(:update) { true }

        schema '$ref' => '#/definitions/single_error'
        run_test!
      end

      response '404', 'user not exist' do
        let(:logged_user) { create :user }
        let(:id) { 1_000_000 }

        let(:start_date) { Time.zone.now }
        let(:end_date) { start_date }

        let!(:worklog1) { create(:worklog, user_id: logged_user.id, date: start_date) }
        let!(:worklog2) { create(:worklog, user_id: logged_user.id, date: start_date) }
        let!(:worklog3) { create(:worklog, user_id: logged_user.id, date: (start_date - 1.day)) }

        schema '$ref' => '#/definitions/single_error'
        # run_test!
      end
    end
  end

  path '/api/users/reported' do
    get 'Retrieves a list of reported users' do
      tags 'Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :start_date,
                in: :query,
                type: :date,
                description: 'start date',
                required: true,
                schema: {
                  type: :date,
                  example: 1
                }

      parameter name: :end_date,
                in: :query,
                type: :date,
                description: 'end date',
                required: true,
                schema: {
                  type: :date,
                  example: 1
                }

      response '200', 'Returns reported users' do
        let(:logged_user) { create :user }
        let(:id) { logged_user.id }

        let(:start_date) { 1.month.ago }
        let(:end_date) { Time.zone.now }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:reported]).to be_an_instance_of(Array)
        end
      end
    end
  end

  path '/api/users/search' do
    post 'Retrieves a list of users by skills' do
      tags 'Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    tags: {
                      type: :array,
                      required: true,
                      items: {
                        type: :string,
                        example: 'skillOne'
                      }
                    }
                  }
                }

      response '200', 'Returns skilled users' do
        let(:logged_user) { create :user }
        let(:id) { logged_user.id }
        let(:params) { { tags: %w[skillOne skillTwo] } }

        run_test!
      end
    end
  end
end
