# frozen_string_literal: true

module Repositories
  class Endpoints
    def initialize(storage)
      @storage = storage
    end

    def add(endpoint)
      storage.write(collection: :endpoints, value: endpoint)
    end

    private

    attr_reader :storage
  end
end
