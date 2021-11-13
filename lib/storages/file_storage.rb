# frozen_string_literal: true
require 'pstore'

module Storages
  class FileStorage
    FILE = 'echo.store'

    def initialize
      # the true flag makes it thread safe
      @store = PStore.new(FILE, true)
    end

    def write(collection:, value:)
      store.transaction do
        store[collection] ||= []
        store[collection].push(value)
      end
    end

    def fetch_collection(collection)
      store.transaction(true) { store[collection] }.to_a
    end

    def truncate
      store.transaction do
        store.roots.each do |root|
          store.delete(root)
        end
      end
    end

    private

    attr_reader :store
  end
end
