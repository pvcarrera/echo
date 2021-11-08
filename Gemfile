# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'committee'
gem 'rack'

group :test do
  gem 'rack-test'
  gem 'rspec'
end

group :development do
  gem 'rubocop', require: false
end

group :development, :test do
  gem 'pry'
end
