require 'rubygems'
require 'bundler/setup'
require 'json'
require 'httparty'
require 'rack'
require 'redis'
require 'sinatra'
require "sinatra/json"
require 'logger'
require 'dotenv/load'
$stdout.sync = true if development?
require './init'
require './slack_response'
require './akashi'
require './main'

run Sinatra::Application
