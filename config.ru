require './app'

require 'rack/cors'
# https://github.com/cyu/rack-cors
use Rack::Cors do
  allow do
    origins 'localhost:9000', '127.0.0.1:9000',
            /http:\/\/192\.168\.0\.\d{1,3}(:\d+)?/
            # regular expressions can be used here

    resource '/entries/*',
        :methods => [:get, :post, :put, :delete, :options],
        :headers => 'x-domain-token',
        :expose  => ['Some-Custom-Response-Header'],
        :max_age => 600
        # headers to expose
  end

  allow do
    origins '*'
    resource '/public/*', :headers => :any, :methods => :get
  end
end

require 'rack/parser'
# https://github.com/achiu/rack-parser
use Rack::Parser, :parsers => {
  'application/json' => proc { |body| JSON.parse(body, symbolize_names: false) }
}

map('/api') { 
  run API::Entries 
}
run Sinatra::Application
# run Rack::Cascade.new [API::Base, Sinatra::Application]