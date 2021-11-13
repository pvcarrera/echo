# frozen_string_literal: true

require 'spec_helper'
require 'storages/file_storage'
require 'ostruct'

RSpec.describe Storages::FileStorage do
  subject(:storage) { described_class.new }
  let(:object) { OpenStruct.new(test: 'text') }

  after(:each) { storage.truncate }

  describe '#fetch_collections' do
    context 'when the collection does not exist' do
      it 'returns an empty array' do
        expect(storage.fetch_collection(:test)).to eq([])
      end
    end
  end

  describe '#write' do
    it 'stores objects into a file' do
      storage.write(collection: :test, value: object)

      expect(storage.fetch_collection(:test)).to eq([object])
    end

    context 'when the collection already exists' do
      before { storage.write(collection: :test, value: object) }

      it 'adds a new value to the collection' do
        storage.write(collection: :test, value: object)
        expect(storage.fetch_collection(:test)).to eq([object, object])
      end
    end
  end
end
