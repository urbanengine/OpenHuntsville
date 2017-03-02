Pakyow::App.routes do
  include SharedRoutes
  fn :require_auth do
    log_debug("/app/lib/routes.rb :: require_auth :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: require_auth :: cookies[:people] :: ", cookies[:people])
    current_user = People[cookies[:people]]
    view.scope(:optin).apply(current_user)
    redirect(router.group(:session).path(:new)) unless cookies[:people]
  end

  get '/' do
    log_debug("/app/lib/routes.rb :: default :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:people] :: ", cookies[:people])
    log_debug("/app/lib/routes.rb :: default :: cookies :: ", cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: ", params.to_s)
    view.scope(:head).apply(request)
    current_user = People[cookies[:people]]
    view.scope(:optin).apply(current_user)
    view.scope(:main_menu).apply(request)
  end

  default do
    log_debug("/app/lib/routes.rb :: default :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:people] :: ", cookies[:people])
    log_debug("/app/lib/routes.rb :: default :: cookies :: ", cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: ", params.to_s)
    view.scope(:head).apply(request)
    current_user = People[cookies[:people]]
    view.scope(:optin).apply(current_user)
    view.scope(:main_menu).apply(request)
  end

  get :login, '/login' do
    log_debug("/app/lib/routes.rb :: login :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: login :: cookies[:people] :: ", cookies[:people])
    current_user = People[cookies[:people]]
    unless current_user.nil?
      view.scope(:optin).apply(current_user)
    end
    reroute router.group(:session).path(:new)
  end

  get :logout, '/logout' do
    reroute router.group(:session).path(:remove), :delete
  end
  get :about, '/about' do
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
    current_user = People[cookies[:people]]
    view.scope(:optin).apply(current_user)
  end
  get :terms, '/terms' do
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
    current_user = People[cookies[:people]]
    view.scope(:optin).apply(current_user)
  end

  get :find, '/find' do
    log_debug("/app/lib/routes.rb :: default :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:people] :: ", cookies[:people])
    log_debug("/app/lib/routes.rb :: default :: cookies :: ", cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: ", params.to_s)

    view.scope(:people).apply(People.all)
    current_user = People[cookies[:people]]
    view.scope(:optin).apply(current_user)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end

  get :dashboard, '/dashboard', :before => :is_admin_check do
    # NOAH
    unapproved = People.where(:approved=>false).all
    pp unapproved
    subset = Array.new
    unapproved.each{|person|
      unless person.spam
        subset.push(person)

      end
    }
    current_user = People[cookies[:people]]
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
    people = People[cookies[:people]]
  	if people.nil?
      redirect "/"
    end
    view.scope(:optin).apply(people)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
  post '2_0' do
    current_user = People[cookies[:people]]
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
    current_user = People[cookies[:people]]
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
    people = People[cookies[:people]]
  	if people.nil?
      redirect "/"
    end
    view.scope(:optin).apply(people)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
  post '2_0' do
    current_user = People[cookies[:people]]
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
    current_user = People[cookies[:people]]
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
end
