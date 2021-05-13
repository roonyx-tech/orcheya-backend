require 'swagger_helper'

describe 'Admin - User resource' do
  include Devise::Test::IntegrationHelpers

  path '/api/admin/users/without_updates' do
    get 'without updates' do
      tags 'Admin - Updates report'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :start_date,
                in: :query,
                type: :date,
                example: '15-05-2020'

      parameter name: :end_date,
                in: :query,
                type: :date,
                example: '15-05-2020'

      parameter name: :users_ids,
                in: :query,
                type: :array,
                example: [1, 2, 3]

      response '200', 'success' do
        let(:start_date) { '15-05-2020' }
        let(:end_date) { '16-05-2020' }
        let(:users_ids) { [Permission.find_by(subject: :notifications, action: :remind_update).users.ids] }
        let(:logged_user) { create :admin }

        before do
          permission = Permission.find_or_create_by(subject: :notifications, action: :remind_update)
          role = FactoryBot.create :role, permissions: [permission]
          users = FactoryBot.create_list :user, 10, :invite_accepted, :with_role, :old

          users.each do |user|
            user.roles << role
            update = FactoryBot.build :update, user: user, date: '15-05-2020'.to_date
            update.save(validate: false)
          end
        end

        run_test!
      end
    end
  end

  path '/api/admin/users/updates' do
    get 'updates' do
      tags 'Admin - Updates report'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :start_date,
                in: :query,
                type: :date,
                example: '15-05-2020'

      parameter name: :end_date,
                in: :query,
                type: :date,
                example: '15-05-2020'

      response '200', 'success' do
        let(:start_date) { '15-05-2020' }
        let(:end_date) { '16-05-2020' }
        let(:logged_user) { create :admin }

        before do
          permission = Permission.find_or_create_by(subject: :notifications, action: :remind_update)
          role = FactoryBot.create :role, permissions: [permission]
          users = FactoryBot.create_list :user, 10, :invite_accepted, :with_role, :old

          users.each do |user|
            update = FactoryBot.build :update, user: user, date: '15-05-2020'.to_date
            user.roles << role
            update.save(validate: false)
          end

          create :vacation_event_approved, started_at: '15-05-2020', ended_at: '16-05-2020', user: users.sample
        end

        run_test!
      end
    end
  end

  path '/api/admin/users/count' do
    get 'Count' do
      tags 'Admin - Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :year,
                in: :query,
                type: :integer,
                example: 2019,
                required: true

      response '200', 'success' do
        let(:logged_user) { create :admin }
        let!(:users) { create_list(:user, 10) }
        let!(:deleted_user) { create :deleted_user }
        let(:year) { 2019 }

        run_test!
      end
    end
  end

  path '/api/admin/users/count_average' do
    get 'Count' do
      tags 'Admin - Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :start_year,
                in: :query,
                type: :integer,
                example: 2019,
                required: true

      parameter name: :end_year,
                in: :query,
                type: :integer,
                example: 2020,
                required: true

      response '200', 'success' do
        let(:logged_user) { create :admin }
        let!(:users) { create_list(:user, 10) }
        let!(:deleted_user) { create :deleted_user }
        let(:start_year) { 2019 }
        let(:end_year) { 2020 }

        run_test!
      end
    end
  end

  path '/api/admin/users' do
    get 'Index' do
      tags 'Admin - Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'success' do
        let(:logged_user) { create :admin }
        let!(:users) { create_list(:user, 2) }
        let!(:invited_user) { create :user, :invited }
        let(:role) { create :role }
        let!(:deleted_user) { create :deleted_user, roles: [role] }

        run_test!
      end
    end

    post 'Retrieves a timegraph' do
      tags 'Admin - Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    email: {
                      type: :string,
                      example: 'str',
                      required: true
                    },
                    role_id: {
                      type: :integer,
                      example: 1,
                      required: true
                    }
                  }
                }

      response '200', 'success' do
        let(:logged_user) { create :admin }
        let(:id) { logged_user.id }

        let(:role) { create :role }
        let(:params) do
          {
            role_id: role.id,
            email: 'user@roonyx.tech'
          }
        end

        run_test!
      end

      response '422', 'success' do
        let(:logged_user) { create :admin }
        let(:params) { { email: 'wrong_email_format' } }

        run_test!
      end
    end
  end

  path '/api/admin/users/{id}/impersonate' do
    post 'Login as other user' do
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

      let!(:logged_user) { create :admin }
      let(:user) { create :user }
      let(:id) { user.id }

      response '200', 'successfully logged in as other user' do
        run_test!
      end
    end
  end

  path '/api/admin/users/stop_impersonating' do
    post 'Return to the true user' do
      tags 'Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      let!(:logged_user) { create :admin }
      let(:user) { create :user }
      let(:id) { user.id }

      before do
        sign_in(logged_user)
        post impersonate_admin_user_url(user.id)
      end

      response '200', 'successfully logged out (from other user account)' do
        run_test!
      end
    end
  end

  path '/api/admin/users/{id}' do
    put 'Update working hours' do
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
                        english_level: { type: :integer, example: 1 },
                        working_hours: { type: :integer, example: 35 }
                      },
                      required: %w[roles]
                    }
                  },
                  required: true
                }
      response '200', 'working hours updated' do
        let(:logged_user) { create :admin }
        let!(:user) { create :user }
        let(:id) { user.id }
        let(:body) do
          { user: { name: 'test',
                    roles: [user.roles.first],
                    working_hours: 50 } }
        end

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          user = data[:user]
          expect(user[:working_hours]).to eq(50)
        end
      end
    end

    put 'update user data' do
      tags 'Admin - Users'
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
                        roles: { type: :bigint, example: [1] }
                      },
                      required: %w[roles]
                    }
                  },
                  required: true
                }

      response '200', 'employment date updated' do
        let(:logged_user) { create :admin }
        let!(:user) { create :user }
        let(:id) { user.id }
        let(:body) do
          { user: { name: 'test', roles: [user.roles.first],
                    employment_at: Time.zone.today.to_s } }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          user = data[:user]
          expect(user[:employment_at]).to eq(Time.zone.today.to_s)
        end
      end

      response '422', 'unprocessable_entity' do
        let(:logged_user) { create :admin }
        let!(:user) { create :user }
        let(:id) { user.id }
        let(:body) do
          { user: { name: '', roles: [user.roles.first],
                    surname: '', email: '' } }
        end
        run_test!
      end
    end

    delete 'destroy user' do
      tags 'Admin - Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                example: 1,
                in: :path,
                type: :integer,
                required: true

      response '200', 'success' do
        let(:logged_user) { create :admin }
        let!(:user) { create :user }
        let(:id) { user.id }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:logged_user) { nil }
        let(:id) { 1 }

        run_test!
      end

      response '403', 'forbidden' do
        let(:logged_user) { create :user }
        let(:id) { logged_user.id }

        run_test!
      end

      response '404', 'not found' do
        let(:logged_user) { create :user }
        let(:id) { 999 }

        run_test!
      end
    end
  end

  path '/api/admin/users/{id}/edit' do
    get 'edit user' do
      tags 'Admin - Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                example: 1,
                in: :path,
                type: :integer,
                required: true

      response '200', 'success' do
        let(:logged_user) { create :admin }
        let!(:user) { create :user }
        let(:id) { user.id }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:user][:id]).to eq(user.id)
        end
      end
    end
  end

  path '/api/admin/users/{id}/restore' do
    get 'restore user' do
      tags 'Admin - Users'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                example: 1,
                in: :path,
                type: :integer,
                required: true

      response '200', 'success' do
        let(:logged_user) { create :admin }
        let!(:user) { create :deleted_user }
        let(:id) { user.id }

        run_test!
      end
    end
  end
end
