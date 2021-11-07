# frozen_string_literal: true

require 'echo_api'
require 'rack/test'

RSpec.describe EchoAPI do
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.parse_file('config.ru').first
  end

  def request_object
    last_request
  end

  describe 'a GET request to the endpoints resource' do
    it 'returns a list of available mock endpoints' do
      get '/endpoints'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('')
      expect(last_response.header).to eq({})
    end
  end
end
