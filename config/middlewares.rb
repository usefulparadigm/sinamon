# config/middlewares.rb
require 'rack/parser'

module Middlewares
  def self.extended(builder)
    # builder.use Rack::Lint

    # require 'rack/cors'
    # # https://github.com/cyu/rack-cors
    # builder.use Rack::Cors do
    #   allow do
    #     origins 'localhost:9000', '127.0.0.1:9000',
    #             /http:\/\/192\.168\.0\.\d{1,3}(:\d+)?/
    #             # regular expressions can be used here
    #
    #     resource '/entries/*',
    #         :methods => [:get, :post, :put, :delete, :options],
    #         :headers => 'x-domain-token',
    #         :expose  => ['Some-Custom-Response-Header'],
    #         :max_age => 600
    #         # headers to expose
    #   end
    #
    #   allow do
    #     origins '*'
    #     resource '/public/*', :headers => :any, :methods => :get
    #   end
    # end

    # https://github.com/achiu/rack-parser
    # http://recipes.sinatrarb.com/p/middleware/rack_parser
    builder.use Rack::Parser, :parsers => {
      # 'application/json' => proc { |data| JSON.parse data }
      'application/json' => proc { |body| JSON.parse(body, symbolize_names: false) }
    }

    builder.use Rack::Session::Cookie,
        :secret => "PLACEHOLDER FOR SECRET", # $ openssl rand -base64 16 
        :expire_after => 2592000 #30 days in seconds 

    # warden authentication
    require_relative './warden'

    builder.use Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app = Sinatra::Application
    end

    # https://github.com/mkdynamic/omniauth-facebook
    builder.use OmniAuth::Builder do
      provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']
    end

  end
end
