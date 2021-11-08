# frozen_string_literal: true

require 'rack'

class EchoAPI
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    Rack::Response.new({ data: [] }.to_json, 200, { 'Content-Type' => 'application/vdn.api+json' })
  end
end
