Pakyow::App.routes do

  fn :require_auth do
    puts "/app/lib/routes.rb :: require_auth :: session :: " + session.to_s
    puts "/app/lib/routes.rb :: require_auth :: cookies[:user] :: " + cookies[:user]
    redirect(router.group(:session).path(:new)) unless session[:user]
  end

  default do
    puts "/app/lib/routes.rb :: default :: session :: " + session.to_s
    puts "/app/lib/routes.rb :: default :: cookies[:user] :: " + cookies[:user]
    view.scope(:user).apply(User.all)
  end

  get :login, '/login' do
    puts "/app/lib/routes.rb :: login :: session :: " + session.to_s
    puts "/app/lib/routes.rb :: login :: cookies[:user] :: " + cookies[:user]
    reroute router.group(:session).path(:new)
  end

  get :logout, '/logout' do
    puts "/app/lib/routes.rb :: logout :: session :: " + session.to_s
    uid = cookies[:user]
    puts "/app/lib/routes.rb :: logout :: cookies[:user] :: " + uid
    cookies[:user] = 0
    puts "REMOVED COOKIE FOR USER ID " + uid
    puts "/app/lib/routes.rb :: logout :: cookies[:user] :: " + uid
    reroute router.group(:session).path(:remove), :delete
  end
end