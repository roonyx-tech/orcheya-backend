require 'swagger_helper'

describe 'Admin - Skill Types API' do
  path '/api/admin/skill_types' do
    get 'index' do
      tags 'Admin - Skill Types'
      security [apiKey: []]
      produces 'application/json'

      response '401', 'needs to be signed in' do
        run_test!
      end

      response '200', 'returns list of Skill Types' do
        let(:logged_user) { create :admin }
        let(:skill_type) { create :skill_type }

        run_test!
      end
    end

    post 'create' do
      tags 'Admin - Skill Types'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :skill_type,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    title: {
                      type: :string,
                      example: 'str',
                      required: true
                    }
                  }
                }

      response '401', 'needs to be signed in' do
        let(:skill_type) do
          { title: Faker::Lorem.word }
        end

        run_test!
      end

      response '200', 'create skill type' do
        let(:logged_user) { create :admin }

        let(:skill_type) do
          { title: Faker::Lorem.word }
        end

        run_test!
      end

      response '422', 'failure' do
        let(:logged_user) { create :admin }
        let(:skill_type) { nil }

        run_test!
      end
    end
  end

  path '/api/admin/skill_types/{id}' do
    get 'show' do
      tags 'Admin - Skill Types'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                required: true

      response '401', 'needs id' do
        let(:id) { nil }

        run_test!
      end

      response '401', 'needs to be signed in' do
        let(:skill_type) { create :skill_type }
        let(:id) { skill_type.id }

        run_test!
      end

      response '200', 'returns skill type' do
        let(:logged_user) { create :admin }
        let(:skill_type) { create :skill_type }
        let(:id) { skill_type.id }

        run_test!
      end
    end

    put 'update' do
      tags 'Admin - Skill Types'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                required: true

      parameter name: :skill_type,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    title: {
                      type: :string,
                      example: 'str',
                      required: true
                    }
                  }
                }

      response '401', 'needs to be signed in' do
        let(:id) { nil }
        let(:skill_type) { create :skill_type }
        let(:id) { skill_type.id }

        run_test!
      end

      response '200', 'returns skill type' do
        let(:logged_user) { create :admin }
        let(:created_skill_type) { create :skill_type }
        let(:id) { created_skill_type.id }
        let(:skill_type) do
          { title: 'test' }
        end

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:title]).to eq('test')
        end
      end

      response '422', 'failure' do
        let(:logged_user) { create :admin }
        let(:created_skill_type) { create :skill_type }
        let(:id) { created_skill_type.id }
        let(:skill_type) do
          { title: nil }
        end

        run_test!
      end
    end

    delete 'destroy' do
      tags 'Admin - Skill Types'
      security [apiKey: []]

      parameter name: :id,
                in: :path,
                type: :integer,
                required: true

      parameter name: :new_skill_type,
                in: :query,
                type: :integer,
                required: true

      response '401', 'failure' do
        let(:id) { -1 }
        let(:new_skill_type) { nil }

        run_test!
      end

      response '200', 'skill type' do
        let(:logged_user) { create :admin }
        let(:skill_type_1) { create :skill_type, title: 'Type 1' }
        let(:skill_type_2) { create :skill_type, title: 'Type 2' }
        let!(:skill) { create :skill, skill_type: skill_type_1, users: [logged_user] }
        let(:id) { skill_type_1.id }
        let(:new_skill_type) { skill_type_2.id }

        run_test!
      end
    end
  end
end
