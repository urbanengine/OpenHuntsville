module SharedRoutes
  include Pakyow::Routes

  fn :route_head do
  end

  fn :edit_profile_check do
  	people = People[cookies[:people]]
  	if people.nil?
      redirect "/errors/401"
    	end
    redirect_no_access = true
    if people.admin
      redirect_no_access = false
    elsif people.id.to_s == params[:people_id] && people.approved
      redirect_no_access = false
    end
    if redirect_no_access
  	  redirect "/errors/403"
  	end
  end

end