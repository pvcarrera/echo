# frozen_string_literal: true

require 'echo_api'
require 'rack/test'
require 'committee'
require 'pry'

RSpec.describe EchoAPI do
  include Rack::Test::Methods
  include Committee::Test::Methods

  let!(:app) do
    @app ||= Rack::Builder.parse_file('config.ru').first
  end
  let!(:endpoints_repository) { Repositories::Endpoints.new }

  let!(:committee_options) do
    api_definition_path = File.join(
      File.dirname(__FILE__),
      '../../openapi_spec/echo_api.yml'
    )
    @committee_options ||= { schema: Committee::Drivers.load_from_file(api_definition_path) }
  end
  let!(:file_storage) { Storages::FileStorage.new }
  # Committee::Test needs this method
  let(:request_object) { last_request }
  # Committee::Test needs this method
  let(:response_data) { [last_response.status, last_response.headers, last_response.body] }
  let(:response_body) { JSON.parse(last_response.body, symbolize_names: true) }

  after(:each) { file_storage.truncate }

  describe 'a GET request to the endpoints resource' do
    it 'returns an empty list' do
      get '/endpoints'

      assert_response_schema_confirm
    end

    context 'when there are available endpoints' do
      let(:request) { Entities::Request.new(verb: 'GET', path: '/greeting') }
      let(:response) { Entities::Response.new(code: 200, headers: {}, body: { message: 'Hello world' }) }
      let(:endpoint) { Entities::Endpoint.new(request: request, response: response) }

      before { endpoints_repository.add(endpoint) }

      it 'returns list of available mock endpoints' do
        get '/endpoints'

        expect(response_body[:data]).not_to be_empty
        assert_response_schema_confirm
      end
    end
  end

  describe 'request unsuported HTTP verb' do
    it 'returns a 404 error' do
      put '/endpoints'

      expect(last_response.status).to eq(404)
    end
  end

  describe 'request to an undefined endpoint' do
    it 'returns a 404 error' do
      get '/undefined'

      expect(last_response.status).to eq(404)
    end
  end

  describe 'a POST request to the endpoint resource' do
    let(:request_body) do
      {
        data: {
          type: 'endpoints',
          attributes: {
            verb: 'GET',
            path: '/greeting',
            response: {
              code: 200,
              headers: { 'Connection' => 'Keep-Alive' },
              body: '{"message":"Hello world"}'
            }
          }
        }
      }
    end

    it 'returns the newly created endpoint' do
      header 'Content-Type', 'application/vnd.api+json'
      post '/endpoints', request_body.to_json

      assert_response_schema_confirm
    end
  end
end
