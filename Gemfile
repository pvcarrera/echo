# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'committee'
gem 'jsonapi-serializers'
gem 'puma'
gem 'rack'
gem 'roda'
gem 'zeitwerk'

group :test do
  gem 'rack-test'
  gem 'rspec'
end

group :development do
  gem 'rubocop', require: false
  gem 'solargraph'
end

group :development, :test do
  gem 'pry'
end
