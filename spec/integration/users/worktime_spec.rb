require 'swagger_helper'

describe 'Users - Worktime API' do
  path '/api/users/{user_id}/worktime' do
    get 'Show' do
      tags 'Users - Worktime'
      security [apiKey: []]
      produces 'application/json'

      parameter name: :user_id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      response '200', 'returns user worktime' do
        let(:logged_user) { create :user, permissions: { users: :busy } }
        let(:user_id) { logged_user.id }
        let(:project) { create :project }
        before do
          create :worklog, user: logged_user, project: project, date: Time.zone.yesterday, length: 10.hours
        end

        run_test! do
          expect(response.body).to_not be_blank
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data).to_not be_blank
          expect(data[:working_time]).to_not be_nil
          expect(data[:worked_out]).to_not be_nil
          expect(data[:balance]).to_not be_nil
          expect(data[:start]).to_not be_nil
          expect(data[:finish]).to_not be_nil
        end
      end
    end
  end

  path '/api/users/{user_id}/worktime_by_projects' do
    get 'Show' do
      tags 'Users - Worktime'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_id,
                in: :path,
                type: :integer,
                example: 1,
                required: true

      parameter name: :start_date,
                in: :query,
                type: :date,
                example: 1.month.ago.to_date,
                required: true

      parameter name: :finish_date,
                in: :query,
                type: :date,
                example: 1.month.ago.to_date,
                required: true

      response '200', 'returns user worktime by projects' do
        date = 1.month.ago
        let(:start_date) { date.beginning_of_month.to_date }
        let(:finish_date) { date.end_of_month.to_date }
        let(:logged_user) { create :user, permissions: { users: :busy }, created_at: start_date }
        let(:user_id) { logged_user.id }
        let(:project) { create :project, name: 'project_name' }
        before do
          create :worklog, user: logged_user, project: project, date: date, length: 10.hours
        end

        run_test! do
          expect(response.body).to_not be_blank
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data).to_not be_blank
          expect(data[:working_time_by_projects][:project_name]).to eq 100
        end
      end
    end
  end
end
