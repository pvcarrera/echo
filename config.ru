# frozen_string_literal: true

require 'committee'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib")
loader.setup

use(
  Committee::Middleware::RequestValidation,
  schema_path: './openapi_spec/echo_api.yml',
  error_class: Errors::Request,
  query_hash_key: 'rack.request.query_hash',
  parse_response_by_content_type: false
)
run EchoApi.freeze.app
