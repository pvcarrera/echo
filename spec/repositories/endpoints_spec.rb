# frozen_string_literal: true

require 'spec_helper'
require 'repositories/endpoints'
require 'entities/endpoint'

RSpec.describe Repositories::Endpoints do
  let(:storage) { spy }

  describe '#add' do
    let(:endpoint) { instance_double(Entities::Endpoint) }

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

  describe '#find_by_request' do
    let(:request) { Entities::Request.new(verb: 'GET', path: '/greeting') }
    let(:response) { instance_double(Entities::Response) }
    let(:endpoint) { Entities::Endpoint.new(request: request, response: response) }

    let(:storage) do
      instance_double(Storages::FileStorage, fetch_collection: [endpoint, endpoint])
    end

    it 'returns the first matching request' do
      expect(described_class.new(storage).find_by_request(request)).to eq(endpoint)
    end
  end
end
