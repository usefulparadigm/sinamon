require './config/base'

# get '/gumby' do
#   erb :gumby, :layout => false
# end
#
# get '/login/?' do
#   redirect '/' if warden.authenticated?
#   erb :login, :layout => false
# end

get '/' do
  @entries ||= Entry.all
  erb :index
end
