require 'sinatra/base'
require 'warden'

Warden::Manager.before_failure do |env, opts|
  # Sinatra is very sensitive to the request method
  # since authentication could fail on any type of method, we need
  # to set it for the failure app so it is routed to the correct block
  env['REQUEST_METHOD'] = "POST"
end

module Sinatra
  module Warden
    
    module Helpers

      # The main accessor to the warden middleware
      def warden
        request.env['warden']
      end

      # Return session info
      #
      # @param [Symbol] the scope to retrieve session info for
      def session_info(scope=nil)
        scope ? warden.session(scope) : scope
      end

      # Check the current session is authenticated to a given scope
      def authenticated?(scope=nil)
        scope ? warden.authenticated?(scope) : warden.authenticated?
      end
      alias_method :logged_in?, :authenticated?

      # Authenticate a user against defined strategies
      def authenticate(*args)
        warden.authenticate!(*args)
      end
      alias_method :login, :authenticate

      # Terminate the current session
      #
      # @param [Symbol] the session scope to terminate
      def logout(scopes=nil)
        scopes ? warden.logout(scopes) : warden.logout(warden.config.default_scope)
      end

      # Access the user from the current session
      #
      # @param [Symbol] the scope for the logged in user
      def user(scope=nil)
        scope ? warden.user(scope) : warden.user
      end
      alias_method :current_user, :user

      # Store the logged in user in the session
      #
      # @param [Object] the user you want to store in the session
      # @option opts [Symbol] :scope The scope to assign the user
      # @example Set John as the current user
      #   user = User.find_by_name('John')
      def user=(new_user, opts={})
        warden.set_user(new_user, opts)
      end
      alias_method :current_user=, :user=

      # Require authorization for an action
      #
      # @param [String] path to redirect to if user is unauthenticated
      def authorize!(failure_path=nil)
        unless authenticated?
          session[:return_to] = request.path if options.auth_use_referrer
          redirect(failure_path ? failure_path : options.auth_failure_path)
        end
      end

    end
    
    def self.registered(app)
      app.helpers Warden::Helpers

      # Classic authentication

      app.post '/unauthenticated/?' do
        status 401
        # warden.custom_failure!
        redirect '/login'
      end
      
      app.post '/login/?' do
        env['warden'].authenticate!
        redirect "/"
      end
      
      app.get '/logout/?' do
        warden.logout
        redirect '/'
      end

      # SPA authentication
      
      app.post '/unauthenticated_auth/?' do
        status 401
        warden.custom_failure!
        {auth: 'nok'}.to_json
      end

      app.post '/auth/?', :provides => :json do
        warden.authenticate! :action => 'unauthenticated_auth'
        {
          auth: 'ok',
          id: user.id,
          name: user.name,
          email: user.email
        }.to_json
      end
      
      # check auth status
      app.get '/auth/?', :provides => :json do
        warden.authenticate! :action => 'unauthenticated_auth'
        {
          auth: 'ok',
          id: user.id,
          name: user.name,
          email: user.email
        }.to_json
      end 

      app.post '/logout/?', :provides => :json  do
        warden.logout
        {auth: 'nok'}.to_json
      end
      
    end
  end
  
  register Warden
end
