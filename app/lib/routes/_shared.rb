module SharedRoutes
  include Pakyow::Routes

  fn :route_head do
  	puts request
  	puts view
  	puts :head
  	unless request.nil? || view.nil?
	  view.scope(:head).apply(request)
    end
  end

  fn :edit_profile_check do
  	people = People[cookies[:people]]
	if people.nil?
	  log_debug("/app/lib/routes/people.rb :: edit :: people is nil")
      redirect "/errors/401"
  	end
	unless people.id.to_s == params[:people_id].to_s || people.admin == true
	  log_debug("/app/lib/routes/people.rb :: edit :: people.id != params[:people_id]")
	  log_debug(people.id)
	  log_debug(params)
	  redirect "/errors/403"
	end
  end

end