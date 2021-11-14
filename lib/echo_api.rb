# frozen_string_literal: true

require 'rack'
require 'request_handlers/endpoints'

class EchoAPI
  DEFAULT_RESPONSE_HEADERS = { 'Content-Type' => 'application/vdn.api+json' }.freeze

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    resource = request.path.scan(/\w+/).first.to_s.capitalize
    http_verb = request.request_method.to_s.downcase

    # "RequestHandlers::#{resource}" is a naming convention that will be used to select
    # the corresponding request handler class.
    request_handler_clazz = Object.const_get("RequestHandlers::#{resource}")
    response = request_handler_clazz.new(request).public_send(http_verb)

    Rack::Response.new(response.body.to_json, response.status, response.headers)
  rescue NoMethodError => e
    handle_no_method_error(e)
  rescue NameError => e
    handle_name_error(e)
  end

  private

  attr_reader :request

  def not_found_response
    Rack::Response.new('Not Found'.to_json, 404, DEFAULT_RESPONSE_HEADERS)
  end

  def handle_no_method_error(error)
    raise error unless %i[get post put head patch delete].include?(error.name)

    # the resource exist but it doe not support the requested HTTP verb
    not_found_response
  end

  def handle_name_error(error)
    raise error unless error.original_message.include?('RequestHandlers')

    # resource handler does not exist
    not_found_response
  end
end
