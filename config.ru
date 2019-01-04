# config.ru
require_relative './config/boot'
require_relative './config/middlewares'
self.extend Middlewares

map('/api/v1') {
  run API::Entries
  # run Rack::Cascade.new [API::Entries, API::Feeds]
}

require './app'
run Sinatra::Application