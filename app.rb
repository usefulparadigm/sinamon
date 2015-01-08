require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'sinatra/config_file'
require 'sinatra/namespace' # http://www.sinatrarb.com/contrib/namespace.html
# require 'sinatra/json' # http://www.sinatrarb.com/contrib/json.html
require 'sinatra/static_assets'
require 'mongoid'
Dir.glob(File.join(File.dirname(__FILE__), 'lib/**/*.rb')).each { |file| require file  }
Dir.glob(File.join(File.dirname(__FILE__), '{models,helpers,routes}/*.rb')).each { |file| require file }

# http://recipes.sinatrarb.com/p/middleware/rack_parser
require 'rack/parser'
use Rack::Parser, :parsers => { 
  'application/json' => proc { |data| JSON.parse data }
}

config_file File.join(File.dirname(__FILE__), './config/config.yml')
# alias :settings :config

set :public_folder, Proc.new { File.join(root, '../public') }

# https://github.com/rkh/rack-protection#readme
# set :protection, :except => [:remote_token, :frame_options]
set :cache_enabled, false
# enable :sessions

configure :development do 
  also_reload File.join(File.dirname(__FILE__), './models/*.rb')
  also_reload File.join(File.dirname(__FILE__), './helpers/*.rb')
  also_reload File.join(File.dirname(__FILE__), './routes/*.rb')
end

configure do
  Mongoid.load!(File.join(File.dirname(__FILE__), './config/mongoid.yml'))
end

# warden authentication
require_relative './config/warden'

use Rack::Session::Cookie, 
    :secret => "PLACEHOLDER FOR SECRET", # $ openssl rand -base64 16 
    :expire_after => 2592000 #30 days in seconds 

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = Sinatra::Application
end

helpers do
  include ApplicationHelper
  # add your helpers here
end

before do
  # authenticate unless request.path_info == '/login'
end

not_found do
  'This is nowhere to be found.'
end
 
error do
  'Sorry there was a nasty error - ' + env['sinatra.error'].name
end

get '/login/?' do
  redirect '/' if warden.authenticated?
  erb :login, :layout => false
end

get '/' do
  # send_file File.join(settings.public_folder, 'index.html')
  erb :index
end

