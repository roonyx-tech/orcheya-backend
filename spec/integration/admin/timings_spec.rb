require 'swagger_helper'

describe 'Admin - Timing resource' do
  path '/api/admin/timings' do
    get 'Retrieves timings' do
      tags 'Admin - Timings'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'success' do
        let(:logged_user) { create :admin }

        let(:count_timings_from_seeds) { 4 }
        let!(:timing1) { create :timing }
        let!(:timing2) { create :timing }
        let(:count_all_timings) { count_timings_from_seeds + 2 }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(
            data[:timings].map { |t| t[:id] }
          ).to include(timing1.id)
          expect(
            data[:timings].map { |t| t[:id] }
          ).to include(timing2.id)
          expect(data[:timings].size).to eq(count_all_timings)
        end
      end
    end

    post 'Create a timing' do
      tags 'Admin - Timings'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :timing,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    start: {
                      type: :datetime,
                      required: false,
                      example: Time.current
                    },
                    end: {
                      type: :datetime,
                      required: false,
                      example: Time.current
                    },
                    flexible: {
                      type: :boolean,
                      required: false,
                      example: true
                    }
                  }
                }

      response '200', 'success' do
        let(:logged_user) { create :admin }

        let(:timing) do
          {
            start: Time.current,
            end: Time.current
          }
        end

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:logged_user) { create :admin }

        let(:timing) do
          {
            start: nil,
            end: nil
          }
        end

        run_test!
      end
    end
  end

  path '/api/admin/timings/{id}' do
    get 'Show on timing' do
      tags 'Admin - Timings'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                required: true

      response '200', 'success' do
        let(:logged_user) { create :admin }

        let!(:timing1) { create :timing }
        let!(:timing2) { create :timing }

        let(:id) { timing1.id }

        run_test!
      end
    end

    put 'Update on timing' do
      tags 'Admin - Timings'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                required: true

      parameter name: :timing,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    start: {
                      type: :datetime,
                      required: false,
                      example: Time.current
                    },
                    end: {
                      type: :datetime,
                      required: false,
                      example: Time.current
                    },
                    flexible: {
                      type: :boolean,
                      required: false,
                      example: true
                    }
                  }
                }

      response '200', 'success' do
        let(:logged_user) { create :admin }

        let!(:timing1) { create :timing }

        let(:id) { timing1.id }

        let(:timing) do
          {
            start: Time.current,
            end: Time.current
          }
        end

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:logged_user) { create :admin }

        let!(:timing1) { create :timing }

        let(:id) { timing1.id }

        let(:timing) do
          {
            start: nil,
            end: nil
          }
        end

        run_test!
      end
    end

    delete 'destroy' do
      tags 'Admin - Timings'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                required: true

      parameter name: :new_timing,
                in: :query,
                type: :integer,
                required: true

      response '200', 'success' do
        let!(:timing1) { create :timing }
        let!(:timing2) { create :timing }
        let(:logged_user) { create :admin, timing: timing1 }
        let(:id) { timing1.id }
        let(:new_timing) { timing2.id }

        run_test!
      end
    end
  end
end
