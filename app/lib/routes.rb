Pakyow::App.routes do
  include SharedRoutes
  fn :require_auth do
    log_debug("/app/lib/routes.rb :: require_auth :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: require_auth :: cookies[:userinfo] :: ", cookies[:userinfo])
    current_user = get_user_from_cookies()
    view.scope(:optin).apply(current_user)
    redirect '/auth/auth0'
  end

  get '/' do
    log_debug("/app/lib/routes.rb :: default :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:userinfo] :: ", cookies[:userinfo])
    log_debug("/app/lib/routes.rb :: default :: cookies :: ", cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: ", params.to_s)
    view.scope(:head).apply(request)
    current_user = get_user_from_cookies()
    view.scope(:optin).apply(current_user)
    view.scope(:main_menu).apply(request)
  end

  default do
    log_debug("/app/lib/routes.rb :: default :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:userinfo] :: ", cookies[:userinfo])
    log_debug("/app/lib/routes.rb :: default :: cookies :: ", cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: ", params.to_s)
    view.scope(:head).apply(request)
    current_user = get_user_from_cookies()
    view.scope(:optin).apply(current_user)
    view.scope(:main_menu).apply(request)
  end

  get :login, '/login' do
    log_debug("/app/lib/routes.rb :: login :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: login :: cookies[:userinfo] :: ", cookies[:userinfo])
    current_user = get_user_from_cookies()
    unless current_user.nil?
      view.scope(:optin).apply(current_user)
    end
    reroute '/auth/auth0'
  end

  get :logout, '/logout' do
    domain = ENV['AUTH0_DOMAIN']
    client_id = ENV['AUTH0_CLIENT_ID']
    request_params = {
      returnTo: ENV['AUTH0_LOGOUT_REDIRECT_URL'],
      client_id: client_id
    }
    cookies[:userinfo] = nil
    redirect URI::HTTPS.build(host: domain, path: '/v2/logout', query: request_params.to_query).to_s
  end
  get :about, '/about' do
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
    current_user = get_user_from_cookies()
    view.scope(:optin).apply(current_user)
  end
  get :terms, '/terms' do
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
    current_user = get_user_from_cookies()
    view.scope(:optin).apply(current_user)
  end

  get :find, '/find' do
    log_debug("/app/lib/routes.rb :: default :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:userinfo] :: ", cookies[:userinfo])
    log_debug("/app/lib/routes.rb :: default :: cookies :: ", cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: ", params.to_s)

    view.scope(:people).apply(People.all)
    current_user = get_user_from_cookies()
    view.scope(:optin).apply(current_user)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end

  get :dashboard, '/dashboard', :before => :is_admin_check do
    unapproved = People.where(:approved=>true).invert.all
    subset = Array.new
    unapproved.each{|person|
      unless person.spam
        subset.push(person)

      end
    }
    current_user = get_user_from_cookies()
    view.scope(:optin).apply(current_user)
    view.scope(:people).apply(subset)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
  get '/errors/401' do
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
  get '/errors/404' do
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
  get '/errors/403' do
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
  get '/errors' do
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
  get '/2_0' do
    people = get_user_from_cookies()
  	if people.nil?
      redirect "/"
    end
    view.scope(:optin).apply(people)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
  post '2_0' do
    current_user = get_user_from_cookies()
  	if current_user.nil?
      redirect "/"
    end
    if params['opt'] == 'in'
      current_user.opt_in = true
      current_user.opt_in_time = Time.now
      current_user.save
    elsif params['opt'] == 'out'
      current_user.opt_in = false
      current_user.opt_in_time = Time.now
      current_user.save
    end
    redirect '/2_0_opted'
  end
  get '2_0_opted' do
    current_user = get_user_from_cookies()
    unless current_user.nil?
      if current_user.opt_in_time.nil?
        redirect '/'
      end
      if current_user.opt_in
        view.scope(:message).use(:in)
      else
        view.scope(:message).use(:out)
      end
    else
      view.scope(:message).use(:empty)
    end
    view.scope(:optin).apply(current_user)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
  get '/2_0' do
    people = get_user_from_cookies()
  	if people.nil?
      redirect "/"
    end
    view.scope(:optin).apply(people)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
  post '2_0' do
    current_user = get_user_from_cookies()
  	if current_user.nil?
      redirect "/"
    end
    if params['opt'] == 'in'
      current_user.opt_in = true
      current_user.opt_in_time = Time.now
      current_user.save
    elsif params['opt'] == 'out'
      current_user.opt_in = false
      current_user.opt_in_time = Time.now
      current_user.save
    end
    redirect '/2_0_opted'
  end
  get '2_0_opted' do
    current_user = get_user_from_cookies()
    unless current_user.nil?
      if current_user.opt_in_time.nil?
        redirect '/'
      end
      if current_user.opt_in
        view.scope(:message).use(:in)
      else
        view.scope(:message).use(:out)
      end
    else
      view.scope(:message).use(:empty)
    end
    view.scope(:optin).apply(current_user)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end

  get 'login/' do
    redirect '/auth/auth0'
  end
end
