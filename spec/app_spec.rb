require_relative './spec_helper'

describe 'my app' do
  
  it "/ should say hello" do
    get '/'
    last_response.must_be :ok?
    last_response.body.must_include 'Hello World!'
  end
  
end
