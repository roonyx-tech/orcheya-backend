require 'swagger_helper'

describe 'Event API' do
  let(:user) { create :user }

  path '/api/events' do
    get 'index' do
      tags 'Events'
      security [apiKey: []]
      produces 'application/json'

      parameter name: :tag_ids, in: :query, type: :array, required: false
      parameter name: :start, in: :query, type: :string, required: false
      parameter name: :finish, in: :query, type: :string, required: false

      response '401', 'needs to be signed in' do
        run_test!
      end

      response '200', 'returns list of event tags' do
        let(:logged_user) { user }
        let(:event) { create :event }

        run_test!
      end

      response '200', 'returns list of event with dates' do
        let(:logged_user) { user }
        let(:event) { create :event }
        let(:start) { event.started_at - 1.day }
        let(:finish) { event.ended_at + 1.day }

        run_test!
      end

      response '200', 'returns list of event tags with filters' do
        let(:logged_user) { user }
        let(:tag_ids) { [tag.id] }
        let!(:event) { create :event }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[0][:id]).to eq(event.id)
        end
      end

      response '200', 'returns blank list of event tags with filters' do
        let(:logged_user) { user }
        let(:tag_ids) { [tag2.id] }
        let!(:event) { create :event }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data).to match_array([])
        end
      end
    end

    post 'create' do
      tags 'Events'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :event,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    title: {
                      type: :string,
                      example: 'str',
                      required: true
                    },
                    type: {
                      type: :string,
                      example: 'common',
                      required: true
                    },
                    description: {
                      example: 'str',
                      type: :string
                    },
                    started_at: {
                      type: :datetime,
                      example: Time.current,
                      required: true
                    },
                    ended_at: {
                      type: :datetime,
                      example: Time.current,
                      required: true
                    },
                    all_day: {
                      example: true,
                      type: :boolean
                    },
                    tag: {
                      example: 'sick',
                      type: :string
                    },
                    project_id: {
                      example: 1,
                      type: :integer
                    }
                  }
                }

      response '401', 'failure' do
        let(:event) { nil }

        run_test!
      end

      response '401', 'needs to be signed in' do
        let(:event) { build :event }

        run_test!
      end

      response '422', 'my event' do
        let(:logged_user) { user }
        let(:event) { build :event, title: '' }

        run_test!
      end

      response '200', 'create common event' do
        let(:logged_user) { user }
        let(:event) do
          build :event, started_at: Date.yesterday, ended_at: Date.tomorrow
        end

        run_test!
      end

      response '200', 'create with tag' do
        let(:logged_user) { user }
        let(:event) do
          {
            title: 'BOT TEST',
            type: 'common',
            description: 'BOT TEST',
            started_at: 1.day.ago.to_date,
            ended_at: Time.zone.today,
            tag: 'day_off'
          }
        end

        run_test!
      end

      response '200', 'create project event' do
        let(:logged_user) { create :user, permissions: { projects: :planning } }
        let(:project) { create :project }
        let(:event) do
          build :project_event, started_at: Date.yesterday, ended_at: Date.tomorrow, project: project
        end

        run_test!
      end
    end
  end

  path '/api/events/{id}' do
    put 'update' do
      tags 'Events'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                required: true

      parameter name: :event,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    title: {
                      type: :string,
                      example: 'str',
                      required: true
                    },
                    description: {
                      example: 'str',
                      type: :string
                    },
                    started_at: {
                      type: :datetime,
                      example: Time.current,
                      required: true
                    },
                    ended_at: {
                      example: Time.current,
                      type: :datetime,
                      required: true
                    },
                    all_day: {
                      example: true,
                      type: :boolean
                    }
                  }
                }

      response '401', 'needs to be signed in' do
        let(:id) { -1 }
        let(:event) { build :event }

        run_test!
      end

      response '200', 'my event' do
        let(:logged_user) { user }
        let(:id) { created_event.id }
        let(:created_event) do
          create :common_event, user: user, started_at: 1.day.ago, ended_at: 1.day.since
        end
        let(:event) { { title: 'test' } }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:title]).to eq('test')
        end
      end

      response '200', 'uodate event as manage' do
        let(:logged_user) { create :user, permissions: { calendar: :manage_all } }
        let(:id) { created_event.id }
        let(:created_event) do
          create :common_event, user: user, started_at: 1.day.ago, ended_at: 1.day.since
        end
        let(:event) { { title: 'test' } }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:title]).to eq('test')
        end
      end

      response '422', 'my event' do
        let(:logged_user) { user }
        let(:created_event) do
          create :common_event, user: user, started_at: 1.day.ago, ended_at: 1.day.since
        end
        let(:id) { created_event.id }
        let(:event) { { title: '' } }

        run_test!
      end

      response '403', 'someone\'s event' do
        let(:logged_user) { user }
        let(:someone_user) { create :user }
        let(:created_event) { create :event, user: someone_user }
        let(:id) { created_event.id }
        let(:event) do
          { started_at: created_event.started_at, ended_at: created_event.ended_at }
        end

        run_test!
      end
    end

    get 'show' do
      tags 'Events'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                required: true

      response '401', 'needs to be signed in' do
        let(:id) { -1 }
        let(:event) { build :event }

        run_test!
      end

      response '200', 'my event' do
        let(:logged_user) { create :user, permissions: { calendar: :vacation } }
        let(:created_event) do
          create :common_event, user: user, started_at: 1.day.ago, ended_at: 1.day.since
        end
        let(:id) { created_event.id }

        run_test!
      end
    end

    delete 'destroy' do
      tags 'Events'
      security [apiKey: []]

      parameter name: :id,
                in: :path,
                type: :integer,
                required: true

      response '401', 'needs to be signed in' do
        let(:id) { -1 }

        run_test!
      end

      response '200', 'my event' do
        let(:logged_user) { user }
        let(:event) do
          create :common_event, user: user, started_at: 1.day.ago, ended_at: 1.day.since
        end
        let(:id) { event.id }

        run_test!
      end

      response '403', 'someone\'s event' do
        let(:logged_user) { user }
        let(:someone_user) { create :user }
        let(:event) { create :event, user: someone_user }
        let(:id) { event.id }

        run_test!
      end
    end
  end

  path '/api/events/{id}/approve' do
    post 'approve' do
      tags 'Events'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer, required: true

      let(:id) { created_event.id }
      let!(:holiday_event) { create :holiday_event, started_at: Time.zone.today, ended_at: Time.zone.today }
      let(:created_event) do
        create :vacation_event, user: user, started_at: 1.day.ago, ended_at: 1.day.since
      end

      it_behaves_like :needs_authorized_user

      response '200', 'approving' do
        let(:logged_user) { create :user, permissions: { calendar: :vacation } }

        before do
          expect_any_instance_of(VacationNotifier).to receive(:approve)
        end

        run_test! do
          expect(created_event.reload.status).to eq 'approved'
        end
      end
    end
  end

  path '/api/events/{id}/disapprove' do
    post 'approve' do
      tags 'Events'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :event, in: :body,
                schema: {
                  type: :object,
                  properties: {
                    description: {
                      example: 'str',
                      type: :string
                    }
                  }
                }

      let(:id) { created_event.id }
      let(:created_event) do
        create :vacation_event, user: user, started_at: 1.day.ago, ended_at: 1.day.since
      end
      let(:event) { { description: 'test' } }

      it_behaves_like :needs_authorized_user

      response '200', 'disapproving' do
        let(:logged_user) { create :user, permissions: { calendar: :vacation } }

        run_test! do
          expect(created_event.reload.status).to eq 'canceled'
        end
      end

      response '422', 'without description' do
        let(:logged_user) { create :user, permissions: { calendar: :vacation } }
        let(:event) { { description: '' } }

        run_test!
      end
    end
  end
end
