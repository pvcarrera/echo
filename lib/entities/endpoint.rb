# frozen_string_literal: true

require 'forwardable'
require 'securerandom'

module Entities
  class Endpoint
    extend Forwardable

    def_delegators :request, :verb, :path
    def_delegators :response, :code, :headers, :body

    attr_reader :request, :response, :id

    def self.build_from_params(params)
      verb = params.dig('data', 'attributes', 'verb')
      path = params.dig('data', 'attributes', 'path')
      code = params.dig('data', 'attributes', 'response', 'code')
      headers = params.dig('data', 'attributes', 'response', 'headers') || {}
      # The commitee gem adds a default proc to the headers hash.
      # Ruby doesn't have a Marshal format for code.
      # This project uses pstore to persist data.
      # Pstore marshals the objects before persistig them.
      # The next line removes the default proc so the headers can be marshalled.
      headers.default_proc = nil
      body = JSON.parse(params.dig('data', 'attributes', 'response', 'body'))

      new(
        request: Request.new(verb: verb, path: path),
        response: Response.new(code: code, headers: headers, body: body)
      )
    end

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
