require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'sinatra/config_file'
require 'sinatra/namespace' # http://www.sinatrarb.com/contrib/namespace.html
# require 'sinatra/json' # http://www.sinatrarb.com/contrib/json.html
require 'sinatra/static_assets'
require 'mongoid'
require 'kaminari/sinatra'
require 'omniauth/facebook'
require "dotenv"
Dotenv.load

Dir.glob(File.join(File.dirname(__FILE__), 'lib/**/*.rb')).each { |file| require file  }
Dir.glob(File.join(File.dirname(__FILE__), '{models,helpers,api}/*.rb')).each { |file| require file }

configure :development do 
  also_reload File.join(File.dirname(__FILE__), './models/*.rb')
  also_reload File.join(File.dirname(__FILE__), './helpers/*.rb')
  also_reload File.join(File.dirname(__FILE__), './api/*.rb')
end

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
use Rack::Session::Cookie, 
    :secret => "PLACEHOLDER FOR SECRET", # $ openssl rand -base64 16 
    :expire_after => 2592000 #30 days in seconds 

# https://github.com/mkdynamic/omniauth-facebook
use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']
end

# warden authentication
require_relative './config/warden'

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = Sinatra::Application
end

configure do
  Mongoid.load!(File.join(File.dirname(__FILE__), './config/mongoid.yml'))
  # https://github.com/amatsuda/kaminari
  Kaminari.configure do |config|
    config.default_per_page = 10
  end
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

# callback for omniauth-facebook
# https://github.com/omniauth/omniauth/wiki
get '/auth/facebook/callback' do
  auth_hash = env['omniauth.auth'] # => OmniAuth::AuthHash
  user = User.find_or_create_by(uid: auth_hash['uid']) do |u|
    u.email = auth_hash['email']
    u.name = auth_hash['info']['name']
    u.nickname = auth_hash['info']['nickname']
  end
  warden.set_user user
  redirect to('/')  
end

# The default behavior is to redirect to `/auth/failure` except in the case of
# a development `RACK_ENV`, in which case an exception will be raised.
get '/auth/failure' do
  flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
  redirect '/'
end


get '/' do
  # send_file File.join(settings.public_folder, 'index.html')
  erb :index
end

