# frozen_string_literal: true

require 'rack'
require 'entities/endpoint_serializer'
require 'repositories/endpoints'
require 'entities/endpoint'

class EchoAPI
  RESPONSE_HEADERS = { 'Content-Type' => 'application/vdn.api+json' }.freeze

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    response_body = JSONAPI::Serializer.serialize(
      Repositories::Endpoints.new.all,
      is_collection: true
    )

    Rack::Response.new(response_body.to_json, 200, RESPONSE_HEADERS)
  end

  private

  attr_reader :request
end
