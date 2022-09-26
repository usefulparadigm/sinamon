# config/boot.rb
require 'bundler/setup'
require 'mongoid'
# require 'kaminari/sinatra'
require 'kaminari/mongoid'
require 'omniauth/facebook'
require "dotenv"
Dotenv.load

Dir.glob(File.join(File.dirname(__FILE__), '../lib/**/*.rb')).each { |file| require_relative file  }
Dir.glob(File.join(File.dirname(__FILE__), '../{models,helpers,api}/*.rb')).each { |file| require_relative file }
Dir.glob(File.join(File.dirname(__FILE__), '../config/initializers/*.rb')).each { |file| require_relative file  }

#= global configurations
Mongoid.load!(File.join(File.dirname(__FILE__), '../config/mongoid.yml'))

# https://github.com/amatsuda/kaminari
Kaminari.configure do |config|
  config.default_per_page = 10
end

# https://github.com/omniauth/omniauth/wiki/FAQ#omniauthfailureendpoint-does-not-redirect-in-development-mode
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

# https://github.com/ddollar/foreman/wiki/Missing-Output
$stdout.sync = true #if development?
