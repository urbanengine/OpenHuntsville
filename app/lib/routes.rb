Pakyow::App.routes do

  fn :require_auth do
    log_debug("/app/lib/routes.rb :: require_auth :: session :: " + session.to_s)
    log_debug("/app/lib/routes.rb :: require_auth :: cookies[:user] :: " + cookies[:user])
    redirect(router.group(:session).path(:new)) unless session[:user]
  end

  default do
    log_debug("/app/lib/routes.rb :: default :: session :: " + session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:user] :: " + cookies[:user])
    log_debug("/app/lib/routes.rb :: default :: cookies :: " + cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: " + params.to_s)
    view.scope(:user).apply(User.all)

    view.scope(:head).apply(request)
    # view.scope(:head).apply(Object.new)
  end

  get :login, '/login' do
    log_debug("/app/lib/routes.rb :: login :: session :: " + session.to_s)
    log_debug("/app/lib/routes.rb :: login :: cookies[:user] :: " + cookies[:user])
    reroute router.group(:session).path(:new)
  end

  get :logout, '/logout' do
    log_debug("/app/lib/routes.rb :: logout :: session :: " + session.to_s)
    uid = cookies[:user]
    log_debug("/app/lib/routes.rb :: logout :: cookies[:user] :: " + uid)
    cookies[:user] = 0
    log_debug("REMOVED COOKIE FOR USER ID " + uid)
    log_debug("/app/lib/routes.rb :: logout :: cookies[:user] :: " + uid)
    reroute router.group(:session).path(:remove), :delete
  end
end