module ApplicationHelper
  # http://www.gittr.com/index.php/archive/using-rackutils-in-sinatra-escape_html-h-in-rails/
  include Rack::Utils
  alias_method :h, :escape_html

  def path_to(addr, absolute = false)
    uri(addr, absolute == :full ? true : false, true)
  end
  
  def redirect_ajax(url)
    request.xhr? ? url : redirect(url)
  end

  def current?(path, current='current')
    # request.path_info.start_with?(path) ? current:  nil
    request.path_info =~ /^#{path}/ ? current:  nil
  end
  
  def authenticate
    warden.authenticate
    redirect '/login' unless warden.authenticated?
  end

  def pjax?
    request.env['HTTP_X_PJAX']
  end
  
  def layout
    # request.xhr? ? :main : true
    true
  end
  
  def public_html(name)
    send_file File.join(settings.public_folder, "#{name}.html")
  end

  # http://stackoverflow.com/questions/2520546/sinatra-partial-with-data
  def partial(template, locals = {})
    erb(template, :layout => false, :locals => locals)
  end
  
  # def render_template(layout=true)
  #   template = (params[:t] ? "entries/templates/#{params[:t]}" : "entries/templates/#{params[:c]}/#{params[:g]}/index").to_sym
  #   erb template, :layout => layout
  # rescue # fallback to default
  #   erb :'entries/index', :layout => layout
  # end

  # http://blog.laaz.org/tech/2012/12/27/rails-redirect_back_or_default/
  def store_location
    session[:return_to] = request.get? ? request.url : request.referrer
  end

  # def store_location(url=request.url)
  #   session[:return_to] = url
  # end

  def redirect_back_or_default(default = url('/'))
    redirect session.delete(:return_to) || default
  end
  alias_method :redirect_back_or, :redirect_back_or_default

  # for Rack::Protection::AuthenticityToken
  # https://github.com/sinatra/sinatra/blob/master/rack-protection/lib/rack/protection/authenticity_token.rb
  def csrf_token; session[:csrf] end
  def csrf_tag
    %{<input name="authenticity_token" value="#{csrf_token}" type="hidden" />}
  end
  def csrf_meta_tag
    %{<meta name="csrf-token" content="#{csrf_token}">}
  end
  
  def json_status(code, reason)
    status code
    {
      :status => code,
      :reason => reason
    }.to_json
  end

end