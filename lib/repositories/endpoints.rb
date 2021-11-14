# frozen_string_literal: true

require 'storages/file_storage'

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

    private

    attr_reader :storage
  end
end
