# frozen_string_literal: true

require 'spec_helper'
require 'repositories/endpoints'

RSpec.describe Repositories::Endpoints do
  let(:storage) { spy }

  describe '#add' do
    # TODO: Once the entity is defined use an instance double
    let(:endpoint) { double }

    it 'sends a write request to the store' do
      described_class.new(storage).add(endpoint)
      expect(storage).to have_received(:write).with(collection: :endpoints, value: endpoint)
    end
  end

  describe '#all' do
    it 'request all the endpoint objects to the storage' do
      described_class.new(storage).all
      expect(storage).to have_received(:fetch_collection).with(:endpoints)
    end
  end
end
