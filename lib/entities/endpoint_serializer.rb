# frozen_string_literal: true

require 'jsonapi-serializers'

# By default, jsonapi-serializers assumes that the serializer class for Namespace::User is Namespace::UserSerializer
module Entities
  class EndpointSerializer
    include JSONAPI::Serializer
    attribute :verb
    attribute :path
    attribute :response do
      {
        code: object.code,
        headers: object.headers,
        body: object.body.to_json
      }
    end
  end
end
