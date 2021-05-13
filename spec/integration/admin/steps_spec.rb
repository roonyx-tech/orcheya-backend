require 'swagger_helper'

describe 'Admin - Steps API' do
  path '/api/admin/steps/integrations' do
    get 'Get list of steps integrations' do
      tags 'Admin - Steps'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'Get list of steps integrations' do
        let(:logged_user) { create :user, permissions: { admin: :super_admin } }
        run_test!
      end
    end
  end

  path '/api/admin/steps' do
    get 'Get user steps' do
      tags 'Admin - Steps'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns list steps' do
        let(:logged_user) { create :user, permissions: { admin: :super_admin } }
        run_test!
      end
    end

    post 'Create an step' do
      tags 'Admin - Steps'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :step,
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
                          href: {
                            type: :string,
                            example: 'href',
                            required: true
                          },
                          kind: {
                            type: :string,
                            example: 'document',
                            required: true
                          },
                          onboarding_ids: {
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
                          }
                        }
                }

      response '200', 'success' do
        let(:logged_user) { create :user, permissions: { admin: :super_admin } }

        let(:step) do
          {
            name: 'doc',
            link: 'href',
            kind: 'document'
          }
        end

        run_test!
      end

      response '422', 'failure' do
        let(:logged_user) { create :user, permissions: { admin: :super_admin } }

        let(:step) do
          {
            name: nil,
            link: nil
          }
        end

        run_test!
      end
    end
  end

  path '/api/admin/steps/{id}' do
    put 'Update on step' do
      tags 'Admin - Steps'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                required: true

      parameter name: :step,
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
                        href: {
                          type: :string,
                          example: 'href',
                          required: true
                        },
                        kind: {
                          type: :string,
                          example: 'tool',
                          required: true
                        },
                        onboarding_ids: {
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
                        }
                      }
                }

      response '200', 'success' do
        let(:logged_user) { create :user, permissions: { admin: :super_admin } }

        let!(:step1) { create :step }
        let!(:step2) { create :step }

        let(:id) { step1.id }

        let(:step) do
          {
            name: 'doc',
            link: 'href',
            kind: 'tool'
          }
        end

        run_test!
      end

      response '422', 'failure' do
        let(:logged_user) { create :user, permissions: { admin: :super_admin } }

        let!(:step1) { create :step }
        let!(:step2) { create :step }

        let(:id) { step1.id }

        let(:step) do
          {
            name: 'doc',
            kind: 'integration'
          }
        end

        run_test!
      end
    end

    delete 'Delete step' do
      tags 'Admin - Steps'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id,
                in: :path,
                type: :integer,
                required: true

      response '204', 'deleted' do
        let(:logged_user) { create :user, permissions: { admin: :super_admin } }

        let!(:step1) { create :step }
        let!(:step2) { create :step }

        let(:id) { step1.id }

        run_test!
      end
    end
  end
end
