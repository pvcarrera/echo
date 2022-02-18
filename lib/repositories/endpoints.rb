# frozen_string_literal: true

module Repositories
  class Endpoints
    def initialize(storage = Storages::FileStorage.new)
      @storage = storage
    end

    def add(endpoint)
      storage.write(collection: :endpoints, value: endpoint)
    end

    def all
      storage.fetch_collection(:endpoints)
    end

    def find_by_request(request)
      all.find { |endpoint| endpoint.request == request }
    end

    private

    attr_reader :storage
  end
end
