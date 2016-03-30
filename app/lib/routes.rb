Pakyow::App.routes do
  include SharedRoutes
  fn :require_auth do
    log_debug("/app/lib/routes.rb :: require_auth :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: require_auth :: cookies[:people] :: ", cookies[:people])
    redirect(router.group(:session).path(:new)) unless session[:people]
  end



  get '/' do
    log_debug("/app/lib/routes.rb :: default :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:people] :: ", cookies[:people])
    log_debug("/app/lib/routes.rb :: default :: cookies :: ", cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: ", params.to_s)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end

  default do
    log_debug("/app/lib/routes.rb :: default :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:people] :: ", cookies[:people])
    log_debug("/app/lib/routes.rb :: default :: cookies :: ", cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: ", params.to_s)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end

  get :login, '/login' do
    log_debug("/app/lib/routes.rb :: login :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: login :: cookies[:people] :: ", cookies[:people])
    reroute router.group(:session).path(:new)
  end

  get :logout, '/logout' do
    uid = cookies[:people]
    cookies[:people] = 0
    reroute router.group(:session).path(:remove), :delete
  end
  get :about, '/about' do
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
  get :terms, '/terms' do
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end

  get :find, '/find' do
    log_debug("/app/lib/routes.rb :: default :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:people] :: ", cookies[:people])
    log_debug("/app/lib/routes.rb :: default :: cookies :: ", cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: ", params.to_s)
    view.scope(:people).apply(People.all)
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
    # pp subset

    view.scope(:people).apply(subset)
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end
end
