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
    Rack::Response.new
  end
end
