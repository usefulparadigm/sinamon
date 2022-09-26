require 'sinatra'
# require 'sinatra/content_for'
# require 'sinatra/config_file'
# require 'sinatra/static_assets'
require 'sinatra/namespace' # http://www.sinatrarb.com/contrib/namespace.html
require 'sinatra/json' # http://www.sinatrarb.com/contrib/json.html

# config_file File.join(File.dirname(__FILE__), './config/config.yml')
# alias :settings :config

set :public_folder, Proc.new { File.join(root, '../public') }

# https://github.com/rkh/rack-protection#readme
# set :protection, :except => [:remote_token, :frame_options]
set :cache_enabled, false
# enable :sessions

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

## logger
# def logger
#   @logger ||= Logger.new(STDOUT)
# end

get '/login/?' do
  redirect '/' if warden.authenticated?
  erb :login, :layout => false
end

# callback for omniauth-facebook
# https://github.com/omniauth/omniauth/wiki
get '/auth/facebook/callback' do
  warden.authenticate :facebook
  redirect to('/')  
end

# OmniAuth failure callback

# https://github.com/omniauth/omniauth/wiki/FAQ#omniauthfailureendpoint-does-not-redirect-in-development-mode
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

# https://github.com/omniauth/omniauth/wiki/FAQ#omniauthfailureendpoint-does-not-redirect-in-development-mode
get '/auth/failure' do
  # flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
  redirect '/'
end

get '/' do
  # send_file File.join(settings.public_folder, 'index.html')
  erb :index
end

