# frozen_string_literal: true

require 'echo_api'
require 'rack/test'
require 'committee'

RSpec.describe EchoAPI do
  include Rack::Test::Methods
  include Committee::Test::Methods

  let!(:app) do
    @app ||= Rack::Builder.parse_file('config.ru').first
  end
  let!(:endpoint_repository) { EndpointsRepository.new }

  let!(:committee_options) do
    api_definition_path = File.join(
      File.dirname(__FILE__),
      '../../openapi_spec/echo_api.yml'
    )
    @committee_options ||= { schema: Committee::Drivers.load_from_file(api_definition_path) }
  end
  # Committee::Test needs this method
  let(:request_object) { last_request }
  # Committee::Test needs this method
  let(:response_data) { [last_response.status, last_response.headers, last_response.body] }

  describe 'a GET request to the endpoints resource' do
    it 'returns an empty list' do
      get '/endpoints'

      assert_response_schema_confirm
    end
  end
end
