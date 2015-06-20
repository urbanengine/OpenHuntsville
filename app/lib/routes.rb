Pakyow::App.routes do

  fn :require_auth do
    log_debug("/app/lib/routes.rb :: require_auth :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: require_auth :: cookies[:people] :: ", cookies[:people])
    redirect(router.group(:session).path(:new)) unless session[:people]
  end

  default do
    log_debug("/app/lib/routes.rb :: default :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:people] :: ", cookies[:people])
    log_debug("/app/lib/routes.rb :: default :: cookies :: ", cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: ", params.to_s)
    view.scope(:people).apply(People.all)
    view.scope(:head).apply(request)
  end

  get :login, '/login' do
    log_debug("/app/lib/routes.rb :: login :: session :: ", session.to_s)
    log_debug("/app/lib/routes.rb :: login :: cookies[:people] :: ", cookies[:people])
    reroute router.group(:session).path(:new)
  end

  get :logout, '/logout' do
    log_debug("/app/lib/routes.rb :: logout :: session :: ", session.to_s)
    uid = cookies[:people]
    log_debug("/app/lib/routes.rb :: logout :: cookies[:people] :: ", uid)
    cookies[:people] = 0
    log_debug("REMOVED COOKIE FOR USER ID " + uid)
    log_debug("/app/lib/routes.rb :: logout :: cookies[:people] :: ", uid)
    reroute router.group(:session).path(:remove), :delete
  end
  get :about, '/about' do
    view.scope(:head).apply(request)
  end
end