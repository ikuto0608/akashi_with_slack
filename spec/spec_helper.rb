require 'rubygems'
require 'bundler/setup'
require 'rack/test'
require 'json'
require 'sinatra'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../init.rb', __dir__)
require File.expand_path('../akashi.rb', __dir__)
require File.expand_path('../main.rb', __dir__)

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixin }
