# api/base.rb
require 'json'

module API
  class Base < Sinatra::Base
    set :method_override, true # enable HTTP POST _method parameter hack
    # set :show_exceptions, false # disable classy error pages

    before do
      content_type 'application/json'
    end

    ## helpers

    def self.put_or_post(*a, &b)
      put *a, &b
      post *a, &b
    end

    helpers do
      def json_status(code, reason)
        status code
        {
          :status => code,
          :reason => reason
        }.to_json
      end
      
      def accept_params(params, *fields)
        h = {}
        fields.each do |name|
          h[name] = params[name] if params[name]
        end
        h
      end
    end

    ## misc handlers: error, not_found, etc.
    get "*" do
      status 404
    end

    put_or_post "*" do
      status 404
    end

    delete "*" do
      status 404
    end

    not_found do
      json_status 404, "Not found"
    end

    error do
      json_status 500, env['sinatra.error'].message
    end

  end
end