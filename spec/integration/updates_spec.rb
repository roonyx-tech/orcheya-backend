require 'swagger_helper'

describe 'Updates API' do
  path '/api/updates' do
    get 'Retrieves updates' do
      tags 'Updates'
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

      parameter name: :query,
                in: :query,
                type: :string,
                description: 'full text search',
                required: false

      parameter name: :user_ids,
                in: :query,
                type: :array,
                items: { type: :integer },
                description: 'filer by user ids',
                required: false

      parameter name: :start_date,
                in: :query,
                type: :string,
                format: :date,
                description: 'filer by date',
                required: false

      parameter name: :end_date,
                in: :query,
                type: :string,
                format: :date,
                description: 'filer by date',
                required: false

      response '200', 'returns updates' do
        let(:logged_user) { create :user }
        let(:page) { 1 }
        before do
          create :update, user: logged_user
        end
        run_test_with_examples!
      end

      response '200', 'returns limited updates' do
        let(:logged_user) { create :user }
        let(:limit) { 1 }
        before do
          create :update, user: logged_user
          create :update, date: Date.current - 1.day, user: logged_user
        end
        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:updates].count).to eq 1
        end
      end

      response '200', 'returns updates with test_text' do
        let(:logged_user) { create :user }
        let(:query) { 'test_text' }
        before do
          create :update, user: logged_user
          create :update,
                 made: 'test_text',
                 planning: 'test_text',
                 issues: 'test_text',
                 date: Date.current - 1.day,
                 user: logged_user
        end

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:updates].count).to eq 1
        end
      end

      response '200', 'returns updates by user_ids' do
        let(:logged_user) { create :user }
        let(:another_user) { create :user }
        let(:user_ids) { [logged_user.id] }
        before do
          create :update, user: another_user
          create :update, user: logged_user, date: Date.current - 1.day
        end

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:updates].count).to eq 1
        end
      end

      response '200', 'returns updates after start_date' do
        let(:logged_user) { create :user }
        let(:another_user) { create :user }
        let(:start_date) { Date.current }
        before do
          create :update, date: start_date - 1.day, user: another_user
          create :update, user: logged_user, date: start_date
        end

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:updates].count).to eq 1
        end
      end

      response '401', 'failure' do
        let(:user_params) { nil }
        run_test_with_examples!
      end
    end

    post 'Post update' do
      tags 'Updates'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :body,
                in: :body,
                schema: {
                  type: :object,
                  properties:
                    {
                      date: {
                        type: :datatime,
                        example: Time.zone.today,
                        required: true
                      },
                      made: {
                        type: :string,
                        example: 'example_text',
                        required: true
                      },
                      planning: {
                        type: :string,
                        example: 'example_text',
                        required: true
                      },
                      issues: {
                        type: :string,
                        example: 'example_text',
                        required: true
                      }
                    }
                }

      context 'user with worklogs' do
        let(:logged_user) { create :user }
        let(:project) { create :project }
        before do
          create :worklog, user: logged_user, project: project, date: Time.zone.today
        end
        response '200', 'Update posted' do
          let(:body) do
            { date: Time.zone.today,
              made: 'test_text',
              planning: 'test_text',
              issues: 'test_text' }
          end

          run_test! do |response|
            data = JSON.parse(response.body, symbolize_names: true)
            update = data[:update]
            expect(update[:made]).to eq('test_text')
          end
        end
      end

      response '422', 'failure' do
        let(:logged_user) { create :user }
        let(:body) { nil }
        run_test!
      end
    end
  end

  path '/api/updates/{id}' do
    put 'Update update' do
      tags 'Updates'
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
                      date: {
                        type: :datatime,
                        example: Time.zone.today,
                        required: true
                      },
                      made: {
                        type: :string,
                        example: 'example_text',
                        required: true
                      },
                      planning: {
                        type: :string,
                        example: 'example_text',
                        required: true
                      },
                      issues: {
                        type: :string,
                        example: 'example_text',
                        required: true
                      }
                    }
                }

      response '200', 'Update updated' do
        let!(:logged_user) do
          user = create :user
          update = create :update, made: 'test_text', planning: 'test_text',
                                   issues: 'test_text', date: Time.zone.today - 1.day
          user.updates << update
          user
        end

        let(:body) do
          { date: Time.zone.today,
            made: 'new_test_text',
            planning: 'test_text',
            issues: 'test_text' }
        end

        let(:id) { logged_user.updates.first.id }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          update = data[:update]

          expect(update[:made]).to eq('new_test_text')
        end
      end

      response '422', 'Unprocessable' do
        let!(:logged_user) do
          user = create :user
          update = create :update, made: 'test_text', planning: 'test_text',
                                   issues: 'test_text', date: Time.zone.today - 1.day
          user.updates << update
          user
        end

        let(:body) do
          { date: nil,
            made: nil,
            planning: nil,
            issues: nil }
        end

        let(:id) { logged_user.updates.first.id }

        run_test!
      end
    end

    get 'Retrieves update' do
      tags 'Updates'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      response '200', 'Update retrieved' do
        let!(:logged_user) do
          user = create :user
          update = create :update, made: 'test_text', planning: 'test_text',
                                   issues: 'test_text', date: Time.zone.today
          user.updates << update
          user
        end

        let(:id) { logged_user.updates.first.id }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          update = data[:update]

          expect(update[:made]).to eq('test_text')
        end
      end
    end
  end
end
