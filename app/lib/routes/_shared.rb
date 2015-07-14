module SharedRoutes
  include Pakyow::Routes

  fn :route_head do
  end

  fn :edit_profile_check do
  	people = People[cookies[:people]]
	if people.nil?
    redirect "/errors/401"
  	end
	unless people.id.to_s == params[:people_id].to_s || people.admin == true
	  redirect "/errors/403"
	end
  end

end