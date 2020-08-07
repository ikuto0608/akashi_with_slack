require 'rubygems'
require 'bundler/setup'
require 'rack/test'
require 'json'
require 'httparty'
require 'mock_redis'
require 'sinatra'
require 'redis'
require 'dotenv/load'
require 'rspec'
require 'vcr'
require 'webmock'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../init.rb', __dir__)
require File.expand_path('../slack_response.rb', __dir__)
require File.expand_path('../akashi.rb', __dir__)
require File.expand_path('../main.rb', __dir__)

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = false
end

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixin }
