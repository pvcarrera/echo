# frozen_string_literal: true
module Entities
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
end
