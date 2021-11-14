# frozen_string_literal: true

require 'forwardable'
require 'securerandom'

module Entities
  # For now the request object only makes sense as part of the Entity.
  # Maybe refactor to Value object
  class Request
    attr_reader :verb, :path

    def initialize(verb:, path:)
      @verb = verb
      @path = path
    end
  end

  # For now the response object only makes sense as part of the Entity.
  # Maybe refactor to Value object
  class Response
    attr_reader :code, :headers, :body

    def initialize(code:, headers:, body:)
      @code = code
      @headers = headers
      @body = body
    end
  end

  class Endpoint
    extend Forwardable

    def_delegators :request, :verb, :path
    def_delegators :response, :code, :headers, :body

    attr_reader :request, :response, :id

    def initialize(request:, response:)
      # Keep an uniq identifier per instance.
      # Create a new endpoint instance will create a new uniq endpoint
      # event if the attributes are the same as an existing one.
      # Attributes validation should be perform in another layer.
      @id = SecureRandom.uuid
      @request = request
      @response = response
    end
  end
end
