# frozen_string_literal: true

# For now the request object only makes sense as part of the Entity.
# Maybe refactor to Value object
module Entities
  class Request
    attr_reader :verb, :path

    def initialize(verb:, path:)
      @verb = verb
      @path = path
    end

    def ==(other)
      verb == other.verb && path == other.path
    end
  end
end
