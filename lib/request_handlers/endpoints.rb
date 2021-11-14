# frozen_string_literal: true

require 'entities/endpoint_serializer'
require 'repositories/endpoints'
require 'entities/endpoint'

module RequestHandlers
  class Endpoints
    RESPONSE_HEADERS = { 'Content-Type' => 'application/vdn.api+json' }.freeze

    def initialize(request)
      @request = request
      @repository = Repositories::Endpoints.new
    end

    def get
      response_body = JSONAPI::Serializer.serialize(repository.all, is_collection: true)

      OpenStruct.new(body: response_body, status: 200, headers: RESPONSE_HEADERS)
    end

    def post
      # At this point the committee middleware has already validate and coerce 
      # the request parameters
      request_parameters = request.env['committee.params']

      endpoint = Entities::Endpoint.build_from_params(request_parameters)
      repository.add(endpoint)
      serialized_endpoint = JSONAPI::Serializer.serialize(endpoint)

      OpenStruct.new(body: serialized_endpoint, status: 201, headers: RESPONSE_HEADERS)
    end

    private

    attr_reader :request, :repository
  end
end
