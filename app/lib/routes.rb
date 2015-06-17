Pakyow::App.routes do

  fn :require_auth do
<<<<<<< HEAD
    puts "/app/lib/routes.rb :: require_auth :: session :: " + session.to_s
    puts "/app/lib/routes.rb :: require_auth :: cookies[:people] :: " + cookies[:people]
    redirect(router.group(:session).path(:new)) unless session[:people]
  end

  default do
    puts "/app/lib/routes.rb :: default :: session :: " + session.to_s
    puts "/app/lib/routes.rb :: default :: cookies[:people] :: " + cookies[:people]
    puts "/app/lib/routes.rb :: default :: cookies :: " + cookies.to_s
    puts "/app/lib/routes.rb :: default :: params :: " + params.to_s
    view.scope(:people).apply(People.all)
=======
    log_debug("/app/lib/routes.rb :: require_auth :: session :: " + session.to_s)
    log_debug("/app/lib/routes.rb :: require_auth :: cookies[:people] :: " + cookies[:people])
    redirect(router.group(:session).path(:new)) unless session[:people]
  end

  default do
    log_debug("/app/lib/routes.rb :: default :: session :: " + session.to_s)
    log_debug("/app/lib/routes.rb :: default :: cookies[:people] :: " + cookies[:people])
    log_debug("/app/lib/routes.rb :: default :: cookies :: " + cookies.to_s)
    log_debug("/app/lib/routes.rb :: default :: params :: " + params.to_s)
    view.scope(:people).apply(People.all)
>>>>>>> master

    view.scope(:head).apply(request)
    # view.scope(:head).apply(Object.new)
  end

  get :login, '/login' do
<<<<<<< HEAD
    puts "/app/lib/routes.rb :: login :: session :: " + session.to_s
    puts "/app/lib/routes.rb :: login :: cookies[:people] :: " + cookies[:people]
=======
    log_debug("/app/lib/routes.rb :: login :: session :: " + session.to_s)
    log_debug("/app/lib/routes.rb :: login :: cookies[:people] :: " + cookies[:people])
>>>>>>> master
    reroute router.group(:session).path(:new)
  end

  get :logout, '/logout' do
<<<<<<< HEAD
    puts "/app/lib/routes.rb :: logout :: session :: " + session.to_s
    uid = cookies[:people]
    puts "/app/lib/routes.rb :: logout :: cookies[:people] :: " + uid
    cookies[:people] = 0
    puts "REMOVED COOKIE FOR USER ID " + uid
    puts "/app/lib/routes.rb :: logout :: cookies[:people] :: " + uid
=======
    log_debug("/app/lib/routes.rb :: logout :: session :: " + session.to_s)
    uid = cookies[:people]
    log_debug("/app/lib/routes.rb :: logout :: cookies[:people] :: " + uid)
    cookies[:people] = 0
    log_debug("REMOVED COOKIE FOR USER ID " + uid)
    log_debug("/app/lib/routes.rb :: logout :: cookies[:people] :: " + uid)
>>>>>>> master
    reroute router.group(:session).path(:remove), :delete
  end
end