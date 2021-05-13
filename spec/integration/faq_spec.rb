require 'swagger_helper'

describe 'Faq API' do
  path '/api/faq' do
    get 'Get sections' do
      tags 'FAQ Sections'
      security [apiKey: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'returns list sections' do
        let(:logged_user) { create :user }
        run_test!
      end
    end

    path '/api/faq/{id}' do
      get 'Show faq section' do
        tags 'FAQ Section'
        security [apiKey: []]
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id,
                  in: :path,
                  type: :integer,
                  example: 1,
                  required: true

        before do
          Section.create(title: 'test_title_show')
        end

        response '200', 'Show section' do
          let(:id) { Section.last.id }
          let(:logged_user) { create :user }

          run_test!
        end
      end
    end
  end
end
