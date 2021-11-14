# frozen_string_literal: true

require './lib/echo_api'

use Committee::Middleware::RequestValidation, schema_path: './openapi_spec/echo_api.yml'
run EchoAPI
