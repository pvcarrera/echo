# frozen_string_literal: true

module Errors
  # This class is used by Committee::Middleware::RequestValidation
  # See call at config.ru
  class Request
    attr_reader :id, :message, :status, :request

    def initialize(status, id, message, request = nil)
      @status = status
      @id = id
      @message = message
      @request = request
    end

    def error_body
      { id: id, message: message }
    end

    def render
      errors = [{title: "Invalid Attribute", detail: message, status: "422" }]
      [
        422,
        { "Content-Type" => "application/vdn.api+json" },
        JSONAPI::Serializer.serialize_errors(errors).to_json
      ]
    end
  end
end

