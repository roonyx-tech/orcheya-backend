require 'rails_helper'
require 'support/login_helpers'
require 'support/integration_helpers'

RSpec.configure do |config|
  config.include LoginHelpers
  config.include IntegrationHelpers
  config.swagger_dry_run = false
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's confiugred to server Swagger from the same folder
  config.swagger_root = Rails.root.to_s + '/swagger'

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:to_swagger' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the messages defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      securityDefinitions: {
        basic: {
          type: :basic
        },
        apiKey: {
          type: :apiKey,
          name: 'Authorization',
          in: :header
        }
      },
      definitions: {
        object: { type: 'object' },
        single_error: {
          type: 'object',
          properties: {
            error: { type: :string }
          }
        },
        errors_object: {
          type: 'object',
          properties: {
            errors: { '$ref' => '#/definitions/errors_map' }
          }
        },
        errors_map: {
          type: 'object',
          additionalProperties: {
            type: 'array',
            items: { type: 'string' }
          }
        }
      }
    }
  }
end

def run_test_with_examples!
  after do |example|
    example.metadata[:response][:examples] = {
      'application/json' => JSON.parse(response.body, symbolize_names: true)
    }
  end

  schema '$ref' => '#/definitions/object'
  run_test!
end
