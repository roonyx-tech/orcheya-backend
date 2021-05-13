require 'swagger_helper'

describe 'Admin - Achievements API' do
  path '/api/admin/achievements' do
    get 'Get user achievements' do
      tags 'Admin - Achievements'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns list achievements' do
        let(:logged_user) { create :user, permissions: { admin: :achievements } }
        run_test!
      end
    end

    post 'Create achievement' do
      tags 'Admin - Achievements'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :body,
                in: :body,
                schema: {
                  type: :object,
                  properties:
                        {
                          title: {
                            type: :string,
                            example: 'title',
                            required: true
                          },
                          kind: {
                            type: :string,
                            example: 'auto'
                          },
                          image: {
                            type: :string,
                            example: 'form_data_string'
                          },
                          endpoint: {
                            type: :string,
                            example: 'name_of_endpoint'
                          },
                          user_ids: {
                            type: :array,
                            items: {
                              type: :integer
                            }
                          },
                          role_ids: {
                            type: :array,
                            items: {
                              type: :integer
                            }
                          },
                          levels_attributes: {
                            type: :array,
                            items: {
                              type: :object,
                              properties: {
                                name: {
                                  type: :string,
                                  example: 'First level'
                                },
                                from: {
                                  type: :integer,
                                  example: 0
                                },
                                to: {
                                  type: :integer,
                                  example: 299
                                },
                                number: {
                                  type: :integer,
                                  example: 1
                                },
                                color: {
                                  type: :string,
                                  example: '#efefef'
                                }
                              }
                            }
                          }
                        }
                }

      response '200', 'Achievement created' do
        let(:logged_user) { create :user, permissions: { admin: :achievements } }
        let(:body) do
          {
            title: 'test_create',
            kind: :auto,
            image: 'uri_of_image.jpg'
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          achievement = data[:achievement]
          expect(achievement[:title]).to eq('test_create')
        end
      end

      response '401', 'needs to be signed in' do
        let(:logged_user) { nil }
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:error]).to eq('You need to sign in or sign up before continuing.')
        end
      end

      response '422', 'failure' do
        let(:logged_user) { create :user, permissions: { admin: :achievements } }
        let(:body) do
          {
            title: 'test_create', kind: :auto, image: 'uri_of_image.jpg',
            levels_attributes: [
              { name: '1', from: 10, to: 5, number: 1, color: '#333', second_color: '#333', third_color: '#333' }
            ]
          }
        end
        run_test!
      end

      response '422', 'failure' do
        let(:logged_user) { create :user, permissions: { admin: :achievements } }
        let(:body) do
          {
            title: 'test_create', kind: :auto, image: 'uri_of_image.jpg',
            levels_attributes: [
              { name: '1', from: 1, to: 5, number: 1, color: '#333', second_color: '#333', third_color: '#333' },
              { name: '2', from: 7, to: 10, number: 2, color: '#333', second_color: '#333', third_color: '#333' }
            ]
          }
        end
        run_test!
      end

      response '422', 'failure' do
        let(:logged_user) { create :user, permissions: { admin: :achievements } }
        let(:body) do
          {
            title: 'test_create', kind: :auto, image: 'uri_of_image.jpg',
            levels_attributes: [
              { name: '1', from: 1, to: 6, number: 1, color: '#333', second_color: '#333', third_color: '#333' },
              { name: '2', from: 4, to: 10, number: 2, color: '#333', second_color: '#333', third_color: '#333' }
            ]
          }
        end
        run_test!
      end
    end
  end

  path '/api/admin/achievements/{id}' do
    get 'Show achievement' do
      tags 'Admin - Achievements'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      before do
        Achievement.create(title: 'test_title_show', kind: :auto, image: 'href_of_image')
      end

      response '200', 'Show achievement' do
        let(:id) { Achievement.last.id }
        let(:logged_user) { create :user, permissions: { admin: :achievements } }

        run_test!
      end
    end

    put 'Update achievement' do
      tags 'Admin - Achievements'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      parameter name: :body,
                in: :body,
                schema: {
                  type: :object,
                  properties:
                        {
                          title: {
                            type: :string,
                            example: 'title',
                            required: true
                          },
                          kind: {
                            type: :string,
                            example: 'auto'
                          },
                          image: {
                            type: :string,
                            example: 'form_data'
                          },
                          endpoint: {
                            type: :string,
                            example: 'name_of_endpoint'
                          },
                          user_ids: {
                            type: :array,
                            items: {
                              type: :integer
                            }
                          },
                          role_ids: {
                            type: :array,
                            items: {
                              type: :integer
                            }
                          },
                          levels: {
                            type: :array,
                            items: {
                              type: :object,
                              properties: {
                                name: {
                                  type: :string,
                                  example: 'First level'
                                },
                                from: {
                                  type: :integer,
                                  example: 0
                                },
                                to: {
                                  type: :integer,
                                  example: 299
                                },
                                number: {
                                  type: :integer,
                                  example: 3
                                },
                                color: {
                                  type: :string,
                                  example: '#efefef'
                                }
                              }
                            }
                          }
                        }
                }

      let(:logged_user) { create :user, permissions: { admin: :achievements } }

      before do
        user = User.create(name: 'Test', surname: 'Surtest', email: 'sample@roonyx.tech', employment_at: 3.months.ago)
        achievement_cu = Achievement.create(title: 'test', kind: :auto, image: 'href_of_image', users: [user],
                                            endpoint: 'consecutive_updates')
        achievement_cu.levels.create(name: 'test', from: 0, to: 100, color: '#ffffff', number: 1)
        users_achievement_cu = user.users_achievements.first
        users_achievement_cu.set_score

        achievement_wd = Achievement.create(title: 'test_title_2', kind: :auto, image: 'href_of_image', users: [user],
                                            endpoint: 'working_days')
        achievement_wd.levels.create(name: 'test', from: 0, to: 300, color: '#333333', number: 1)
        users_achievement_wd = achievement_wd.users_achievements.first
        users_achievement_wd.set_score

        user_with_role = User.create(name: 'Test_2', surname: 'Surtest_2', email: 'sample_2@roonyx.tech',
                                     employment_at: 5.months.ago)
        role = Role.create(name: 'test_role')
        role2 = Role.create(name: 'test_role_2')
        user_with_role.roles << [role, role2]
        user_with_role.save
      end

      response '200', 'Achievement updated' do
        let(:id) { Achievement.last.id }
        let(:body) do
          {
            title: 'test',
            kind: 'auto',
            image: 'uri_of_image.jpg',
            role_ids: [Role.find_by(name: 'test_role').id]
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          achievement = data[:achievement]
          expect(achievement[:title]).to eq('test')
        end
      end

      response '200', 'Achievement updated' do
        let(:id) { Achievement.last.id }
        let(:body) do
          {
            title: 'test_error',
            kind: 1,
            image: 'uri_of_image.jpg',
            role_ids: Role.all.ids
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          achievement = data[:achievement]
          expect(achievement[:title]).to eq('test_error')
        end
      end

      response '200', 'Achievement updated with and users removed' do
        before do
          User.create(name: 'Test_3', surname: 'Surtest_3', email: 'sample_3@roonyx.tech', employment_at: 3.months.ago,
                      roles: [Role.last])
          achievement = Achievement.last
          achievement.roles << Role.all
          achievement.save
        end
        let(:id) { Achievement.last.id }
        let(:body) do
          {
            title: 'test_error',
            kind: 'auto',
            image: 'uri_of_image.jpg',
            role_ids: [Role.first.id]
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          achievement = data[:achievement]
          expect(achievement[:title]).to eq('test_error')
        end
      end

      response '401', 'needs to be signed in' do
        let(:id) { Achievement.last.id }
        let(:logged_user) { nil }
        let(:body) do
          {
            title: 'test',
            kind: 1,
            image: 'uri_of_image.jpg'
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:error]).to eq('You need to sign in or sign up before continuing.')
        end
      end

      response '422', 'failure' do
        let(:id) { Achievement.last.id }
        let(:body) do
          { title: nil }
        end
        run_test!
      end
    end

    delete 'Delete achievement' do
      tags 'Admin - Achievements'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      before(:each) do
        Achievement.create(title: 'test_title_destroy', kind: :auto, image: 'href_of_image')
      end

      response '204', 'Achievement deleted' do
        let(:id) { Achievement.last.id }
        let(:logged_user) { create :user, permissions: { admin: :achievements } }

        run_test!
      end
    end
  end

  path '/api/admin/achievements/counters' do
    get 'Get list of achievement counters' do
      tags 'Admin - Achievements'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'Get list of counters' do
        let(:logged_user) { create :user, permissions: { admin: :achievements } }
        run_test!
      end
    end
  end
end
