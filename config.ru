require 'rubygems'
require 'bundler/setup'
require 'json'
require 'rack'
require 'sinatra'
$stdout.sync = true if development?
require './init'
require './akashi'
require './main'

run Sinatra::Application
