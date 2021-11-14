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

    private

    attr_reader :request
  end
end
