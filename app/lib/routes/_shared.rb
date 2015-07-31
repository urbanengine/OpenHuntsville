module SharedRoutes
  include Pakyow::Routes

  fn :route_head do
    view.scope(:head).apply(request)
    view.scope(:main_menu).apply(request)
  end

  fn :edit_profile_check do
  	people = People[cookies[:people]]
  	if people.nil?
      redirect "/errors/401"
    	end
    redirect_no_access = true
    if people.admin
      redirect_no_access = false
    elsif people.custom_url == request.path.split('/')[2]
      redirect_no_access = false
    elsif people.id.to_i == request.path.split('/')[2].to_i
      redirect_no_access = false
    end
    pp people
    pp request.path.split('/')
    if redirect_no_access
  	  redirect "/errors/403"
  	end
  end

end