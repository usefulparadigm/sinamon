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
  
  # def render_template(layout=true)
  #   template = (params[:t] ? "entries/templates/#{params[:t]}" : "entries/templates/#{params[:c]}/#{params[:g]}/index").to_sym
  #   erb template, :layout => layout
  # rescue # fallback to default
  #   erb :'entries/index', :layout => layout
  # end

end