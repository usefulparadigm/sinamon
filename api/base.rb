# api/api.rb
require 'grape'
Dir.glob(File.join(File.dirname(__FILE__), './*.rb')).each { |file| require file }

module API
  class Base < Grape::API
    prefix "api"
    version 'v1' #, :using => :header, :vendor => 'vendor'
    format :json

    # load the rest of the APIs
    mount API::Entries
  end
end
