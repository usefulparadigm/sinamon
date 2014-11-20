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
Dir.glob('./lib/**/*.rb').each { |file| require file  }
Dir.glob('./{models,helpers,routes}/*.rb').each { |file| require file }

config_file "./config/config.yml"
# alias :settings :config

# main application file
# http://www.sinatrarb.com/configuration.html
set :app_file, '../'

# https://github.com/rkh/rack-protection#readme
# set :protection, :except => [:remote_token, :frame_options]
set :cache_enabled, false
# enable :sessions

configure :development do 
  also_reload './models/*.rb'
  also_reload './helpers/*.rb'
  also_reload './routes/*.rb'
end

configure do
  Mongoid.load!("./config/mongoid.yml")
end

helpers do
  include ApplicationHelper
  # add your helpers here
end

before do
  authenticate unless request.path_info == '/login'
end

not_found do
  'This is nowhere to be found.'
end
 
error do
  'Sorry there was a nasty error - ' + env['sinatra.error'].name
end
