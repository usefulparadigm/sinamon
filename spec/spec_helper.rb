ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'
require_relative '../app'

class MiniTest::Spec
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
    # Rack::Builder.parse_file(File.dirname(__FILE__) + '/../config.ru').first
  end
end

# Configure test output
# possible values are :pretty, :dot, :cue, :marshal, :outline, :progress
# Turn.config.format = :dot

