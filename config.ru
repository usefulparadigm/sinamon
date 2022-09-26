# config.ru
require_relative './server/config/boot'
require_relative './server/config/middlewares'
self.extend Middlewares

map('/api/v1') {
  run API::Entries
  # run Rack::Cascade.new [API::Entries, API::Feeds]
}

require './server/app'
run Sinatra::Application