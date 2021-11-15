# frozen_string_literal: true

require 'entities/endpoint'
require 'entities/endpoint_serializer'
require 'rack'
require 'repositories/endpoints'
require 'roda'

class EchoAPI < Roda
  plugin :default_headers, 'Content-Type' => 'application/vdn.api+json'

  route do |r|
    r.get 'endpoints' do
      JSONAPI::Serializer.serialize(
        endpoints_repository.all,
        is_collection: true
      ).to_json
    end

    r.post 'endpoints' do
      # At this point the committee middleware has already validate and coerce
      # the request parameters
      endpoint = Entities::Endpoint.build_from_params(request_parameters)
      endpoints_repository.add(endpoint)

      response.status = 201
      JSONAPI::Serializer.serialize(endpoint).to_json
    end

    r.on do
      endpoint = endpoints_repository.find_by_request(
        Entities::Request.new(verb: r.request_method, path: r.path)
      )
      if endpoint
        response.status = endpoint.code
        endpoint.body.to_json
      else
        response.status = 404
        'Not Found'
      end
    end
  end

  private

  def endpoints_repository
    @endpoints_repository ||= Repositories::Endpoints.new
  end

  def request_parameters
    @request_parameters ||= request.env['committee.params']
  end
end
